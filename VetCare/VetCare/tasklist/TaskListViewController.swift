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

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var animals = ["benji", "bolinhas", "bobi"]
    var tasks = ["analises", "raio-x", "desinfetar pontos"]
    var hours = ["09:00", "15:00", "17:30"]
    
    @IBOutlet weak var tableView: UITableView!
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private let service = GTLRCalendarService()
    //let signInButton = GIDSignInButton()
    //let output = UITextView()
    var calendarEvents = [String]()
    var dates = [String]()
    var hoursTasks = [String]()
    var animalsName = [String]()
    var animalsTask = [String]()
    var eventsLoaded = false
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
        // Do any additional setup after loading the view.
        // Configure Google Sign-in.
        
        // Initialize Google sign-in.
        GIDSignIn.sharedInstance().clientID = "1040218745705-lnll051g8m2ji8ftnapopv5nn9no4vrt.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
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
        return 3
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            //self.signInButton.isHidden = true
            //self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Display the start dates and event summaries in the UITextView
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var outputText = ""
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short)
                outputText += "\(startString) - \(event.summary!)"
                calendarEvents.append(outputText)
                outputText = ""
            }
        }
        else {
            let alertController = UIAlertController(title: "VetCare", message:
                "No upcoming events found.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        //output.text = outputText
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
        }

        let defaults = UserDefaults.standard
        defaults.set(calendarEvents, forKey: "eventsForCalendar")
        eventsLoaded = true
        tableView.reloadData()
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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
