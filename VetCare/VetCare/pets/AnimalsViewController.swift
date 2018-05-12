//
//  AnimalsViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 28/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class AnimalsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let animals = ["bobi", "bolinhas", "max", "benji", "rex", "spotty", "flecha", "freddie"]
    let weight = ["11", "12", "7", "10", "8", "15", "13", "20"]
    let owners = ["ana", "joana", "rita", "raquel", "bia", "sofia", "maria", "ines"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
