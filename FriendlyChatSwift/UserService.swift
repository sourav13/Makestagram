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
    static func timeline(pageSize: UInt, lastPostKey: String? = nil, completion: @escaping ([Post]) -> Void) {
        let currentUser = User.current

              let timelineRef = Database.database().reference().child("timeline").child(currentUser.uid)
        var query = timelineRef.queryOrderedByKey().queryLimited(toLast: pageSize)
        if let lastPostKey = lastPostKey {
            query = query.queryEnding(atValue: lastPostKey)
        }

        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
                   guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                       else { return completion([]) }

                   let dispatchGroup = DispatchGroup()

                   var posts = [Post]()

                   for postSnap in snapshot {
                       guard let postDict = postSnap.value as? [String : Any],
                           let posterUID = postDict["poster_uid"] as? String
                           else { continue }

                       dispatchGroup.enter()

                       PostService.show(forKey: postSnap.key, posterUID: posterUID) { (post) in
                           if let post = post {
                               posts.append(post)
                           }

                           dispatchGroup.leave()
                       }
                   }

                   dispatchGroup.notify(queue: .main, execute: {
                       completion(posts.reversed())
                   })
               })
    }

    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
    let followersRef = Database.database().reference().child("followers").child(user.uid)

    followersRef.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let followersDict = snapshot.value as? [String : Bool] else {
            return completion([])
        }

            let followersKeys = Array(followersDict.keys)
            completion(followersKeys)
        })
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
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")

        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }

            // 3
            let users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }

            // 4
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()

                // 5
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }

            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
     let ref = DatabaseReference.toLocation(.posts(uid: user.uid))

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let dispatchGroup = DispatchGroup()

            let posts: [Post] = snapshot.reversed().compactMap {
                guard let post = Post(snapshot: $0)
                    else { return nil }

                dispatchGroup.enter()

                LikeService.isPostLiked(post) { (isLiked) in
                    post.isLiked = isLiked

                    dispatchGroup.leave()
                }

                return post
            }

            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
}
