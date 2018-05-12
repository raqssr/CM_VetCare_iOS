//
//  DriveViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 09/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class DriveViewController: UIViewController {
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
//    private let scopes = [kGTLRAuthScopeDriveReadonly]
//
//    private let service = GTLRDriveService()
//    let signInButton = GIDSignInButton()
//    let output = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Google Sign-in.
//        GIDSignIn.sharedInstance().clientID = "1040218745705-rvs6iv7727f18q27h77ithjr4g0l3uub.apps.googleusercontent.com"
//
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().scopes = scopes
//        GIDSignIn.sharedInstance().signInSilently()
//
//        // Add the sign-in button.
//        view.addSubview(signInButton)
//
//        // Add a UITextView to display output.
//        output.frame = view.bounds
//        output.isEditable = false
//        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        output.isHidden = true
//        view.addSubview(output);
        
        if let appURL = URL(string: "googledrive://*"){
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpen)")
            
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
        print("carregou")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "main")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//            showAlert(title: "Authentication Error", message: error.localizedDescription)
//            self.service.authorizer = nil
//        } else {
//            self.signInButton.isHidden = true
//            self.output.isHidden = false
//            self.service.authorizer = user.authentication.fetcherAuthorizer()
//            listFiles()
//        }
//    }
//
//    // List up to 10 files in Drive
//    func listFiles() {
//        let query = GTLRDriveQuery_FilesList.query()
//        query.pageSize = 10
//        service.executeQuery(query,
//                             delegate: self,
//                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
//        )
//    }
//
//    // Process the response and display output
//    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
//                                 finishedWithObject result : GTLRDrive_FileList,
//                                 error : NSError?) {
//
//        if let error = error {
//            showAlert(title: "Error", message: error.localizedDescription)
//            return
//        }
//
//        var text = "";
//        if let files = result.files, !files.isEmpty {
//            text += "Files:\n"
//            for file in files {
//                text += "\(file.name!) (\(file.identifier!))\n"
//            }
//        } else {
//            text += "No files found."
//        }
//        output.text = text
//    }
//
//
//    // Helper for showing an alert
//    func showAlert(title : String, message: String) {
//        let alert = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: UIAlertControllerStyle.alert
//        )
//        let ok = UIAlertAction(
//            title: "OK",
//            style: UIAlertActionStyle.default,
//            handler: nil
//        )
//        alert.addAction(ok)
//        present(alert, animated: true, completion: nil)
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
