//
//  ProfileViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 29/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var photo: UIImageView!
    
    let images = ["info", "hospitalisation", "historic"]
    let options = ["General Information", "Hospitalisation", "Animal's Record"]
    let segueIdentifiers = ["generalInfo", "hospitalisation", "historic"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photo.layer.cornerRadius = 40
        photo.layer.borderWidth = 1.0
        photo.layer.borderColor = UIColor.clear.cgColor
        photo.layer.masksToBounds = true;
        
        photo.contentMode = UIViewContentMode.scaleAspectFill
        photo.clipsToBounds = true
        
        photo.image = UIImage(named: "benji")
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
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
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
