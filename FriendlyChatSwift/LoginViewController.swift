//
//  LoginViewController.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 11/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseUI


class LoginViewController: UIViewController {
typealias FIRUser = FirebaseAuth.User
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else{
            return
        }
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
          FUIEmailAuth()
        ]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
}
extension LoginViewController: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }

    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        

        guard let user = authDataResult?.user
            else { return }
        

        let userRef = Database.database().reference().child("users").child(user.uid)
        

            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
           
                if let user = User(snapshot: snapshot) {
                    User.setCurrent(user)
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    
                    if let initialViewController = storyboard.instantiateInitialViewController() {
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                } else {
                    self.performSegue(withIdentifier: "toCreateUsername", sender: self)
                }

            })
        
    }
}
