//
//  HospitalisationViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class HospitalisationViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    var views: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        views = [UIView]()
        views.append(GeneralViewController().view)
        views.append(MedicationViewController().view)
        views.append(ProcedureViewController().view)
        
        for v in views {
            viewContainer.addSubview(v)
        }
        
        viewContainer.bringSubview(toFront: views[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        self.viewContainer.bringSubview(toFront: views[sender.selectedSegmentIndex])
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
