//
//  GeneralInfoViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class GeneralInfoViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var specie: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var coat: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerPhone: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
