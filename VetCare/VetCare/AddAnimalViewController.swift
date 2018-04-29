//
//  AddAnimalViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 29/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class AddAnimalViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var specie: UITextField!
    @IBOutlet weak var breed: UITextField!
    @IBOutlet weak var coat: UITextField!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var ownerAddress: UITextField!
    @IBOutlet weak var ownerPhone: UITextField!
    @IBOutlet weak var motive: UITextField!
    @IBOutlet weak var veterinarian: UITextField!
    @IBOutlet weak var observations: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == ownerName || textField == ownerAddress || textField == ownerPhone || textField == motive || textField == veterinarian || textField == observations{
            scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
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
