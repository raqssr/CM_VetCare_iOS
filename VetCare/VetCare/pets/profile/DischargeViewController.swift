//
//  DischargeViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 05/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import TPPDF
import GoogleAPIClientForREST
import GoogleSignIn

class DischargeViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var veterinarian: UITextField!
    @IBOutlet weak var observations: UITextField!
    @IBOutlet weak var pdfGenerator: UIButton!
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeDrive]

    private let service = GTLRDriveService()
    let signInButton = GIDSignInButton()
    
    var loadingView: UIView = UIView()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var pdfGeneratorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = "1040218745705-4451usgufp84li2njpe66u837hhc7o9s.apps.googleusercontent.com"

        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        //signInButton.center = view.center

        // Add the sign-in button.
        view.addSubview(signInButton)
        //self.signInButton.isHidden = true
        self.pdfGeneratorButton.isHidden = true
        //start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generatePDF(_ sender: Any) {
        let html = "<b>Hello <i>World!</i></b> <p>Generate PDF file from HTML in Swift</p>"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Save PDF file

        //let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        //pdfData.write(toFile: "\(documentsPath)/file.pdf", atomically: true)
        
//        var fileData: Data? = FileManager.default.contents(atPath: "/")
//        var metadata = GTLRDrive_File()
//        metadata.name = "example.pdf"
//        var uploadParameters = GTLRUploadParameters(data: fileData!, mimeType: "application/pdf")
//        uploadParameters.shouldUploadWithSingleRequest = true
//        var query = GTLRDriveQuery_FilesCreate.query(withObject: metadata, uploadParameters: uploadParameters)
//        query.fields = "id"
//        self.service.executeQuery(query, completionHandler: {(_ ticket: GTLRServiceTicket, _ object: Any?, _ error: Error?) -> () in
//            if error == nil {
//                if let anIdentifier = (object? as AnyObject).identifier
//                {
//                    //print("File ID \(anIdentifier)")
//                    print("não deu erro")
//                }
//            } else {
//                if let anError = error {
//                    print("An error occurred: \(anError)")
//                }
//            }
//        })
        
        let file = GTLRDrive_File() as GTLRDrive_File
        file.name = "Example.pdf"
        file.descriptionProperty = "Uploaded from Google Drive IOS"
        file.mimeType = "application/pdf"
        let data = pdfData
        let uploadParameters = GTLRUploadParameters(data: data as Data, mimeType: file.mimeType!)
        uploadParameters.shouldUploadWithSingleRequest = true
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        self.service.executeQuery(query, completionHandler:  { (ticket, insertedFile , error) -> Void in
            let myFile = insertedFile as? GTLRDrive_File
            
            if error == nil {
                print("File ID \(myFile?.identifier)")
                print("Google Drive: File Saved")
            } else {
                print("An Error Occurred! \(error)")
                print("Google Drive: Sorry, an error occurred!")
            }
            
        })

//        let document = PDFDocument(format: .a4)
//        document.addText(.contentCenter, text: "Create PDF documents easily.")
//        do {
//            // Generate PDF file and save it in a temporary file. This returns the file URL to the temporary file
//            let url = try PDFGenerator.generateURL(document: document, filename: "Example.pdf", progress: {
//                (progressValue: CGFloat) in
//                print("progress: ", progressValue)
//            }, debug: true)
//
//            // Load PDF into a webview from the temporary file
//            (self.view as? UIWebView)?.loadRequest(URLRequest(url: url))
//        } catch {
//            print("Error while generating PDF: " + error.localizedDescription)
//        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error) != nil {
            showAlert(title: "Google Sign In", message: "You must sign in the first time you run the application in order to be able to save discharge reports in Google Drive.")
            signInButton.center = view.center
            view.addSubview(signInButton)
            self.service.authorizer = nil
        } else {
            signInButton.isHidden = true
            self.pdfGeneratorButton.center = view.center
            self.pdfGeneratorButton.isHidden = false
            stop()
            loadingView.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
        }
    }

    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRDrive_FileList,
                                 error : NSError?) {

        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }

        var text = "";
        if let files = result.files, !files.isEmpty {
            text += "Files:\n"
            for file in files {
                text += "\(file.name!) (\(file.identifier!))\n"
            }
        } else {
            text += "No files found."
        }
    }


    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func start(){
        activityIndicator.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 80, height: 80))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stop(){
        activityIndicator.stopAnimating()
    }
}
