//
//  UserService.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    typealias  FirUser = FirebaseAuth.User
    static func create(_ firUser: FirUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid:String,completion:@escaping (User?)->Void){
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of:.value,with:{(snapshot) in
            guard let user = User(snapshot: snapshot) else{
                return completion(nil)
            }
            completion(user)
        })
    }
    
}
