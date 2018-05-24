//
//  GeneralInfoViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreData

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
    
    var animalName = String()
    var animalDob = String()
    var animalGender = String()
    var animalSpecie = String()
    var animalBreed = String()
    var animalCoat = String()
    var animalWeight = String()
    var animalOwnerName = String()
    var animalOwnerPhone = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
        
        name.text = animalName
        dob.text = animalDob
        gender.text = animalGender
        specie.text = animalSpecie
        breed.text = animalBreed
        coat.text = animalCoat
        weight.text = animalWeight
        ownerName.text = animalOwnerName
        ownerPhone.text = animalOwnerPhone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
        let fetchRequest:NSFetchRequest<Animal> = Animal.fetchRequest()
        do{
            let searchResults = try PersistenceService.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            
            for result in searchResults as [Animal]{
                if result.name! == animalName{
                    animalDob = convertDateToString(date: result.dob! as Date)
                    animalGender = result.gender!
                    animalSpecie = result.specie!
                    animalBreed = result.breed!
                    animalCoat = result.coat!
                    animalWeight = String(result.weight)
                    animalOwnerName = (result.owner?.name)!
                    animalOwnerPhone = String((result.owner?.phone)!)
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
