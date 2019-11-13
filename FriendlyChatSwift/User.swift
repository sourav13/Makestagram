//
//  User.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import Foundation

import FirebaseDatabase.FIRDataSnapshot

class User :Codable{
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    var isFollowed = false
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
    }
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    static func setCurrent(_ user: User,writetoUserDefaults:Bool = false) {
        if writetoUserDefaults{
            if let data = try? JSONEncoder().encode(user){
                UserDefaults.standard.set(data,forKey:Constants.UserDefaults.currentUser)
            }
        }
        _current = user
    }

}
