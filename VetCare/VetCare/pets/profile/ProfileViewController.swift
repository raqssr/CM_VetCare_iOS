//
//  ProfileViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 29/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var animalDobLabel: UILabel!
    @IBOutlet weak var animalOwnerLabel: UILabel!
    
    let images = ["info", "hospitalisation", "historic"]
    let options = ["General Information", "Hospitalisation", "Animal's Record"]
    let segueIdentifiers = ["generalInfo", "hospitalisation", "historic"]
    
    var animalImage = UIImage()
    var name = String()
    var animalDob = String()
    var animalOwner = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photo.layer.cornerRadius = 40
        photo.layer.borderWidth = 1.0
        photo.layer.borderColor = UIColor.clear.cgColor
        photo.layer.masksToBounds = true;
        
        photo.contentMode = UIViewContentMode.scaleAspectFill
        photo.clipsToBounds = true
        
        initData()
        
        photo.image = animalImage
        animalNameLabel.text = name
        animalDobLabel.text = animalDob
        animalOwnerLabel.text = animalOwner
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        cell.imageOption.image = UIImage(named: images[indexPath.row])
        cell.textOption.text = options[indexPath.row]

        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameAnimal = name
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: nameAnimal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generalInfo"{
            let destVC = segue.destination as! GeneralInfoViewController
            destVC.animalName = (sender as? String)!
        }
        if segue.identifier == "hospitalisation"{
            let destVC = segue.destination as! HospitalisationViewController
            destVC.animalName = (sender as? String)!
        }
        if segue.identifier == "historic"{
            let destVC = segue.destination as! HistoricViewController
            destVC.animalName = (sender as? String)!
        }
        if segue.identifier == "writeMessageToUser"{
            let destVC = segue.destination as! SendMessageViewController
            destVC.animalNameMessage = name
        }
        if segue.identifier == "dischargeAnimal"{
            let destVC = segue.destination as! DischargeViewController
            destVC.animalNameReport = name
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initData(){
        let fetchRequest:NSFetchRequest<Animal> = Animal.fetchRequest()
        do{
            let searchResults = try PersistenceService.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Animal]{
                if result.name! == name{
                    animalImage = UIImage(data: result.image! as Data)!
                    animalDob = convertDateToString(date: result.dob! as Date)
                    animalOwner = (result.owner?.name)!
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
