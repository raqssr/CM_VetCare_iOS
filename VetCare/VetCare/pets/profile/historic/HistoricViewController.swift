//
//  HistoricViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreData

class HistoricViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var historic = ["vacina raiva", "chip"]
//    var dates = ["1/1/1", "2/2/2"]

    var historic = [String]()
    var dates = [String]()
    
    var animalName = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historicCell", for: indexPath) as! HistoricTableViewCell
        cell.procName.text = historic[indexPath.row]
        cell.date.text = dates[indexPath.row]
        
        return cell
    }
    
    func initData(){
        var pets = [Animal]()
        let request = NSFetchRequest<Animal>(entityName: "Animal")
        do {
            pets = try PersistenceService.getContext().fetch(request)
            for p in pets {
                if p.name == animalName{
                    for h in p.historic?.allObjects as! [Historic] {
                        historic.append(h.procedures!)
                        dates.append(convertDateToString(date: h.dates! as Date))
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

}
