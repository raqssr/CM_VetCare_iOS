//
//  AddMessageViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 05/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class SendMessageViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var messageBox: UITextView!
    
    var animalNameMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("name message")
        print(animalNameMessage)
        
        // Do any additional setup after loading the view.
        messageBox.text = "Write here!"
        messageBox.layer.cornerRadius = 10
        messageBox.textColor = UIColor.darkGray
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
