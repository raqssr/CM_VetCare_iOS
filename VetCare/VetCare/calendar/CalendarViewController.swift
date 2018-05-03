//
//  CalendarViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 03/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import MBCalendarKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Instatiate a calendar view
        let calendar = CalendarView()
        //Present the calendar view
        self.view.addSubview(calendar)
        //Constraint with auto layout
        let top = self.topLayoutGuide.bottomAnchor
        let center = self.view.centerXAnchor
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: top).isActive = true
        calendar.centerXAnchor.constraint(equalTo: center).isActive = true
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
