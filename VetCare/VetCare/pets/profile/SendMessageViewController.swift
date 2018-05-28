//
//  AddMessageViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 05/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class SendMessageViewController: UIViewController, UITextViewDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var messageBox: UITextView!
    
    var animalNameMessage = String()
    var ownerPhone = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("name message")
        print(animalNameMessage)
        
        // Do any additional setup after loading the view.
        messageBox.text = nil
        messageBox.layer.cornerRadius = 10
        messageBox.textColor = UIColor.darkGray
        self.hideKeyboardWhenTappedAround()
        
        getAnimalOwnerPhone()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessage(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = messageBox.text
            controller.recipients = [ownerPhone]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getAnimalOwnerPhone(){
        let fetchRequest:NSFetchRequest<Animal> = Animal.fetchRequest()
        do{
            let searchResults = try PersistenceService.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            
            for result in searchResults as [Animal]{
                if result.name! == animalNameMessage{
                    ownerPhone = String((result.owner?.phone)!)
                    break
                }
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
