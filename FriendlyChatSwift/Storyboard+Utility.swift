//
//  Storyboard+Utility.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import UIKit

extension UIStoryboard{
    enum MGType:String{
        case main
        case login
        var filename :String{
            return rawValue.capitalized
        }
    }
    convenience init(type:MGType,bundle: Bundle? = nil){
        self.init(name:type.filename,bundle:bundle)
        
    }
    static func initializeViewController(for type:MGType)-> UIViewController{
        let storyboard = UIStoryboard(type:type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else{
            fatalError("could not instantiate initial view controller of type")
        }
        return initialViewController
    }
}
