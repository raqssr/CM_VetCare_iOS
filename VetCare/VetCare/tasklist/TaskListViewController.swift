//
//  TaskListViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var animals = ["benji", "bolinhas", "bobi"]
//    var tasks = ["analises", "raio-x", "desinfetar pontos"]
//    var hours = ["09:00", "15:00", "17:30"]
    
    @IBOutlet weak var tableView: UITableView!

    var dates = [String]()
    var hoursTasks = [String]()
    var animalsName = [String]()
    var animalsTask = [String]()
    var eventsLoaded = false
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var n = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tabBarController?.tabBar.isHidden = false
        
        // Do any additional setup after loading the view
        let defaults = UserDefaults.standard
        let calendarEvents = defaults.object(forKey: "eventsForCalendar") as? [String] ?? [String]()
        
        for i in calendarEvents{
            var eventInfo = i.split(separator: "-")
            var timeInfo = eventInfo[0].trimmingCharacters(in: .whitespaces)
            var taskInfo = eventInfo[1].trimmingCharacters(in: .whitespaces)
            var dateTime = timeInfo.split(separator: ",")
            var date = dateTime[0]
            var time = dateTime[1].trimmingCharacters(in: .whitespaces)
            var animalTask = taskInfo.split(separator: ":")
            var animalName = animalTask[0]
            var task = animalTask[1].trimmingCharacters(in: .whitespaces)
            dates.append(String(date))
            hoursTasks.append(time)
            animalsName.append(String(animalName))
            animalsTask.append(task)
            n = n + 1
            if n == calendarEvents.count{
                eventsLoaded = true
                n = 0
            }
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if animalsName.count != 0 {
            return animalsName.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskListTableViewCell
        if eventsLoaded == true{
            stop()
            cell.animalName.text = animalsName[indexPath.row]
            cell.task.text = animalsTask[indexPath.row]
            cell.hours.text = hoursTasks[indexPath.row]
            return cell
        }
        else{
            start()
            cell.animalName.text = " "
            cell.task.text = " "
            cell.hours.text = " "
            return cell
        }
    }
    
    func start(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stop(){
        activityIndicator.stopAnimating()
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
