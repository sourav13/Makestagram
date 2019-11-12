//
//  MainTabBarController.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
let photoHelper = MGPhotoHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        photoHelper.completionHandler = { image in
               print("handle image")
           }
        delegate = self
        tabBar.unselectedItemTintColor = .black
        // Do any additional setup after loading the view.
    }
    



}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            // present photo taking action sheet
            photoHelper.presentActionSheet(from: self)
            
            return false
        } else {
            return true
        }
    }
}
