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
import CoreData

class DischargeViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var veterinarian: UITextField!
    @IBOutlet weak var observations: UITextField!
    @IBOutlet weak var pdfGenerator: UIButton!
    
    var animalNameReport = String()
    
    var medName = String()
    var medDosage = String()
    var medTotalDays = String()
    
    var procName = String()
    var procDate = String()
    
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
        
        getMedicine()
        getProcedure()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        self.pdfGeneratorButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generatePDF(_ sender: Any) {
        let html = "<b>Discharge Report</b> <p></p> <p>Animal name: \(animalNameReport)</p> <p>Weight: \(weight.text!)</p> <p>Veterinarian: \(veterinarian.text!)</p> <p>Observations: \(observations.text!)</p> <p>Procedures: <ul><li>\(procName) (\(procDate))</li></ul></p> <p>Medicine: <ul><li>\(medName) (Dosage: \(medDosage), Total days: \(medTotalDays))</li></ul></p>"
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
        
        let file = GTLRDrive_File() as GTLRDrive_File
        file.name = "\(animalNameReport).pdf"
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
        
        deleteAndGoBack()
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
    
    func getMedicine(){
        var pets = [Animal]()
        let request = NSFetchRequest<Animal>(entityName: "Animal")
        do {
            pets = try PersistenceService.getContext().fetch(request)
            for p in pets {
                if p.name == animalNameReport{
                    for med in p.medicine?.allObjects as! [Medicine] {
                        medName = (med.name!)
                        medDosage = String(med.dosage)
                        medTotalDays = String(med.totalDays)
                    }
                }
                
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func getProcedure(){
        var pets = [Animal]()
        let request = NSFetchRequest<Animal>(entityName: "Animal")
        do {
            pets = try PersistenceService.getContext().fetch(request)
            for p in pets {
                if p.name == animalNameReport{
                    for proc in p.procedure?.allObjects as! [Procedure] {
                        procName = proc.name!
                        procDate = convertDateToString(date: proc.date! as Date)
                    }
                }
                
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func convertDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date) //according to date format your date string
    }
    
    func deleteAndGoBack()
    {
        let fetchRequest:NSFetchRequest<Animal> = Animal.fetchRequest()
        do{
            let searchResults = try PersistenceService.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Animal]{
                if result.name == animalNameReport{
                    PersistenceService.getContext().delete(result)
                    break
                }
            }
        }
        catch{
            print("Error: \(error)")
        }
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
