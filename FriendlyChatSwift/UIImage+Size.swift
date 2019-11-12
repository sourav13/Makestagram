//
//  UIImage+Size.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import UIKit
extension UIImage{
    var aspectHeight: CGFloat{
        let heightRatio = size.height/736
        let widthRatio = size.width/414
        let aspectRatio = fmax(heightRatio, widthRatio)
        return size.height/aspectRatio
    }
}
