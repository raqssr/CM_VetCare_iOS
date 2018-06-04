//
//  LogOutViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 03/06/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let firebaseAuth = Auth.auth()
        do {
            print(Auth.auth().currentUser!)
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginId")
        self.present(loginVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
