//
//  DriveViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 09/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class DriveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appURL = URL(string: "googledrive://*"){
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            
            let appName = "googledrive"
            let appScheme = "\(appName)://"
            let appSchemeURL = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL){
                UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
            }
            else{
                let alert = UIAlertController(title: "\(appName) Error", message: "The app named \(appName) was not found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "main")
        self.present(vc!, animated: true, completion: nil)
        
    }
}
