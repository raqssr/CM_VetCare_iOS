//
//  HospitalisationViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class HospitalisationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let general_title = ["Entry Date", "Motive", "Veterinarian", "Observations"]
    var general_data = ["a", "b", "c", "d"]
    
    var medicine_name = ["x", "y", "z"]
    var medicine_dosage = ["1", "2", "3"]
    var medicine_frequency = ["4", "5", "6"]
    
    var procedure_name = ["ecografia", "eletrocardiograma", "raio-x"]
    var procedure_date = ["1/1/1", "2/2/2", "3/3/3"]
    
    var p: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nib_general = UINib(nibName: "GeneralTableViewCell", bundle: nil)
        let nib_med = UINib(nibName: "MedicineTableViewCell", bundle: nil)
        let nib_proc = UINib(nibName: "ProcedureTableViewCell", bundle: nil)
        tableView.register(nib_general, forCellReuseIdentifier: "generalCell")
        tableView.register(nib_med, forCellReuseIdentifier: "medicineCell")
        tableView.register(nib_proc, forCellReuseIdentifier: "procedureCell")
        
        p = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if segmentedControl.selectedSegmentIndex == 0{
            return general_title.count
        }
        else if segmentedControl.selectedSegmentIndex == 1{
            return medicine_name.count
        }
        else{
            return procedure_name.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if segmentedControl.selectedSegmentIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "generalCell", for: indexPath) as! GeneralTableViewCell
            cell.titleLabel.text = general_title[indexPath.row]
            cell.dataLabel.text = general_data[indexPath.row]
            return cell
        }
        else if segmentedControl.selectedSegmentIndex == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineTableViewCell
            cell.nameMedicine.text = medicine_name[indexPath.row]
            cell.dosage.text = medicine_dosage[indexPath.row]
            cell.frequency.text = medicine_frequency[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "procedureCell", for: indexPath) as! ProcedureTableViewCell
            cell.procedureName.text = procedure_name[indexPath.row]
            cell.date.text = procedure_date[indexPath.row]
            return cell
        }
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        tableView.reloadData()
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
