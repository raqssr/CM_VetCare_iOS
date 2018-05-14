//
//  AnimalsViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 28/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import CoreLocation

class AnimalsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let animals = ["bobi", "bolinhas", "max", "benji", "rex", "spotty", "flecha", "freddie"]
    let weight = ["11", "12", "7", "10", "8", "15", "13", "20"]
    let owners = ["ana", "joana", "rita", "raquel", "bia", "sofia", "maria", "ines"]
    
    var locationManager: CLLocationManager!
    var nameAnimal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalViewCell", for: indexPath) as! AnimalViewCell
        
        cell.animalImage.image = UIImage(named: animals[indexPath.row])
        cell.animalName.text = animals[indexPath.row].capitalized
        cell.animalWeight.text = weight[indexPath.row]
        cell.animalOwner.text = owners[indexPath.row].capitalized
        
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
        let uuid = UUID(uuidString: "c9804b7e-7193-4937-8aa0-71252fb62c59")!
        nameAnimal = "Benji"
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 50, minor: 0, identifier: "cm2018")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            if  distance == .far || distance == .near || distance == .immediate{
                let alert = UIAlertController(title: "The animal is:", message: self.nameAnimal, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
//            switch distance {
//            case .unknown:
//                self.view.backgroundColor = UIColor.gray
//                self.distanceReading.text = "UNKNOWN"
//
//            case .far:
//                self.view.backgroundColor = UIColor.blue
//                self.distanceReading.text = "FAR"
//
//            case .near:
//                self.view.backgroundColor = UIColor.orange
//                self.distanceReading.text = "NEAR"
//
//            case .immediate:
//                self.view.backgroundColor = UIColor.red
//                self.distanceReading.text = "RIGHT HERE"
//            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
