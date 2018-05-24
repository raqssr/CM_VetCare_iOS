//
//  HospitalisationViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreData

class HospitalisationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let general_title = ["Entry Date", "Motive", "Veterinarian", "Observations"]
    var general_data = [String]()
    
    var medicine_name = [String]()
    var medicine_dosage = [String]()
    var medicine_frequency = [String]()
    
    var procedure_name = [String]()
    var procedure_date = [String]()
    
    var animalName = String()
    
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
        
        initData()
        initMedicine()
        initProcedures()
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
    
    func initData(){
        let fetchRequest:NSFetchRequest<Animal> = Animal.fetchRequest()
        do{
            let searchResults = try PersistenceService.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            
            for result in searchResults as [Animal]{
                if result.name! == animalName{
                    general_data.append((result.internment?.entryDate)!)
                    general_data.append((result.internment?.motive)!)
                    general_data.append((result.internment?.veterinarian)!)
                    general_data.append((result.internment?.observation)!)
                }
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func initMedicine(){
        var pets = [Animal]()
        let request = NSFetchRequest<Animal>(entityName: "Animal")
        do {
            pets = try PersistenceService.getContext().fetch(request)
            for p in pets {
                if p.name == animalName{
                    for med in p.medicine?.allObjects as! [Medicine] {
                        medicine_name.append(med.name!)
                        medicine_dosage.append(String(med.dosage))
                        medicine_frequency.append(String(med.frequency))
                    }
                }
                
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func initProcedures(){
        var pets = [Animal]()
        let request = NSFetchRequest<Animal>(entityName: "Animal")
        do {
            pets = try PersistenceService.getContext().fetch(request)
            for p in pets {
                if p.name == animalName{
                    for proc in p.procedure?.allObjects as! [Procedure] {
                        procedure_name.append(proc.name!)
                        procedure_date.append(convertDateToString(date: proc.date! as Date))
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
