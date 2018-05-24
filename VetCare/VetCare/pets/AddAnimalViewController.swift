//
//  AddAnimalViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 29/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreData

class AddAnimalViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    var animalImage:UIImage? = nil

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
    
    @IBAction func addAnimalButton(_ sender: Any) {
        //store core data
        let newAnimal: Animal = NSEntityDescription.insertNewObject(forEntityName: "Animal", into: PersistenceService.getContext()) as! Animal
        print("criou o animal")
        newAnimal.name = name.text
        newAnimal.gender = gender.text
        newAnimal.dob = convertStringToDate(dateStr: dob.text!) as NSDate
        newAnimal.weight = Double(weight.text!)!
        newAnimal.specie = specie.text
        newAnimal.breed = breed.text
        newAnimal.coat = coat.text
        newAnimal.image = UIImagePNGRepresentation(animalImage!) as NSData?
        print("acabou o animal")
        
        let newOwner: Owner = NSEntityDescription.insertNewObject(forEntityName: "Owner", into: PersistenceService.getContext()) as! Owner
        print("criou o owner")
        newOwner.name = ownerName.text
        newOwner.address = ownerAddress.text
        newOwner.phone = Int32(ownerPhone.text!)!
        print("acabou o owner")
        
        let newInternment: Internment = NSEntityDescription.insertNewObject(forEntityName: "Internment", into: PersistenceService.getContext()) as! Internment
        print("criou o internamento")
        newInternment.entryDate = convertDateToString(date: getCurrentDate())
        newInternment.motive = motive.text
        newInternment.veterinarian = veterinarian.text
        newInternment.observation = observations.text
        print("acabou o internamento")
        
        let newMedicine: Medicine = NSEntityDescription.insertNewObject(forEntityName: "Medicine", into: PersistenceService.getContext()) as! Medicine
        print("criou os medicmentos")
        newMedicine.name = generateRandomMedicine()
        newMedicine.dosage = generateRandomDosage()
        newMedicine.frequency = Int16(generateRandomFrequency())
        newMedicine.totalDays = Int16(generateRandomTotalDays())
        print("acabou os medicamentos")
        
        let newProcedure: Procedure = NSEntityDescription.insertNewObject(forEntityName: "Procedure", into: PersistenceService.getContext()) as! Procedure
        print("criou o procedmento")
        newProcedure.name = generateRandomProcedure()
        newProcedure.date = convertStringToDate(dateStr: generateRandomDate()) as NSDate
        print("acabou o procedimento")
        
        let newHistoric: Historic = NSEntityDescription.insertNewObject(forEntityName: "Historic", into: PersistenceService.getContext()) as! Historic
        print("criou o historic")
        newHistoric.procedures = generateRandomRegular()
        newHistoric.dates = convertStringToDate(dateStr: generateRandomDate()) as NSDate
        print("acabou o historico")
        
        newAnimal.owner = newOwner
        print("associou o owner")
        newAnimal.internment = newInternment
        print("associou o internamento")
        newAnimal.addToMedicine(newMedicine)
        print("associou os medicamentos")
        newAnimal.addToProcedure(newProcedure)
        print("associou os proc")
        newAnimal.addToHistoric(newHistoric)
        print("associou o historico")
        
        print("vai guardar")
        
        PersistenceService.saveContext()
        
        print("guardou")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func convertStringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy" //Your date format
        let date = dateFormatter.date(from: dateStr) //according to date format your date string
        return date!
    }
    
    func convertDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date) //according to date format your date string
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        animalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getCurrentDate() -> Date{
        let currentDate = Date()
        return currentDate
    }
    
    func generateRandomMedicine() -> String{
        let array = ["Banacep", "Dermocanis Alercaps", "Fortekor", "Ecuphar", "Omnipharm", "Intervet International", "Sogeval"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
    
    func generateRandomDosage() -> Double{
        return Double(arc4random_uniform(100) + 25)
    }
    
    func generateRandomFrequency() -> Int{
        return Int(arc4random_uniform(3) + 1)
    }
    
    func generateRandomTotalDays() -> Int{
        return Int(arc4random_uniform(60) + 7)
    }
    
    func generateRandomProcedure() -> String{
        let array = ["Análises", "Tratamento Acupuntura", "Ecocardiograma", "Ecografia Abdominal", "Raio-x", "Vacina Parvovirose", "Vacina Tosse", "Vacina Leucemia"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
    
    func generateRandomDate() -> String{
        let array = ["23/03/2018", "24/03/2018", "27/03/2018", "26/03/2018", "30/03/2018", "02/04/2018", "05/04/2018", "03/04/2018", "04/04/2018"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }
    
    func generateRandomRegular() -> String{
        let array = ["Desparasitação", "Castração", "Tosquia", "Consulta Rotina", "Esterilização", "Microchip", "Vacina Raiva"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
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
