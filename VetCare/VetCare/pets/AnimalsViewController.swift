//
//  AnimalsViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 28/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AnimalsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var animalsNames = [String]()
    var animalsWeight = [Double]()
    var animalsOwners = [String]()
    var animalsImages = [NSData]()
    
    var locationManager: CLLocationManager!
    var nameAnimal = String()
    
    var readData = false
    var beaconRead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        readData = false
        beaconRead = false
        
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animalsNames.removeAll()
        animalsWeight.removeAll()
        animalsImages.removeAll()
        animalsOwners.removeAll()
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if readData == false{
            return 0
        }
        else{
            return animalsNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalViewCell", for: indexPath) as! AnimalViewCell
        
        cell.animalImage.image = UIImage(data: animalsImages[indexPath.row] as Data)
        cell.animalName.text = animalsNames[indexPath.row].capitalized
        cell.animalWeight.text = String(animalsWeight[indexPath.row])
        cell.animalOwner.text = animalsOwners[indexPath.row].capitalized
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true;
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        cell.animalImage.contentMode = UIViewContentMode.scaleAspectFill
        cell.animalImage.clipsToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = animalsNames[indexPath.row]
        performSegue(withIdentifier: "MasterToDetail", sender: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MasterToDetail"{
            let navVC = segue.destination as? UINavigationController
            let destVC = navVC?.viewControllers.first as! ProfileViewController
            destVC.name = (sender as? String)!
        }
    }
    
    @IBAction func identifyAnimal(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "68f9d1e2-7f72-46d9-8722-9d116b2eab2d")!
        nameAnimal = "Benji"
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 50, minor: 0, identifier: "cm2018")
        if beaconRead == false{
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
        else{
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            beaconRead = false
        }
       
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            if  distance == .far || distance == .near || distance == .immediate{
                let alert = UIAlertController(title: "The animal is:", message: self.nameAnimal, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                self.beaconRead = true
                self.startScanning()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func initData(){
        let fetchRequest:NSFetchRequest<Animal> = Animal.fetchRequest()
        do{
            let searchResults = try PersistenceService.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Animal]{
                animalsNames.append(result.name!)
                animalsWeight.append(result.weight)
                animalsOwners.append((result.owner?.name)!)
                animalsImages.append(result.image!)
            }
            readData = true
            collectionView.reloadData()
        }
        catch{
            print("Error: \(error)")
        }
    }
}
