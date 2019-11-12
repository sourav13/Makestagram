//
//  StorageReference+Post.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import Foundation
import FirebaseStorage
extension StorageReference{
    static let dateFormatter  = ISO8601DateFormatter()
    static func newPostImageReference() -> StorageReference{
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
