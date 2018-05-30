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
    
    @IBOutlet weak var tableView: UITableView!
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeCalendar]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    
    var calendarEvents = [String]()
    var dates = [String]()
    var hoursTasks = [String]()
    var animalsName = [String]()
    var animalsTask = [String]()
    var eventsLoaded = false
    var signInDone = false
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var resultQrCode = String()
    var qrCodeRead = false
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = "1040218745705-lnll051g8m2ji8ftnapopv5nn9no4vrt.apps.googleusercontent.com"

        // Initialize Google sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        print("resultQrCode")
        print(resultQrCode)
        
        qrCodeRead = false
        
        self.tableView.isHidden = true
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(TaskListViewController.reloadEventsForTable), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if resultQrCode.isEmpty == false{
            qrCodeRead = true
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func reloadEventsForTable(){
        calendarEvents.removeAll()
        dates.removeAll()
        hoursTasks.removeAll()
        animalsName.removeAll()
        animalsTask.removeAll()
        fetchEvents()
        refresher.endRefreshing()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventsLoaded == false{
            if signInDone == false{
                print("vi que ainda nao foi feito sign in")
                return 0
            }
            else{
                print("ja foi feito sign in")
                start()
                return 0
            }
        }
        else{
            if animalsName.count == 0{
                if qrCodeRead == false{
                    stop()
                    let alert = UIAlertController(title: "Task List", message: "There are no tasks for today!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return 0
                }
                else{
                    return 0
                }
            }
            else{
                return animalsName.count
            }
        }
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
            if signInDone == false{
                print("eventos carregados mas sem start pq sem sign in")
                cell.animalName.text = " "
                cell.task.text = " "
                cell.hours.text = " "
                return cell
            }
            else{
                print("eventos carregados mas c start pq sign in")
                start()
                cell.animalName.text = " "
                cell.task.text = " "
                cell.hours.text = " "
                return cell
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print("vou mostrar o alert")
            showAlert(title: "Google Sign In", message: "You must sign in the first time you run the application in order to be able to access google calendar events.")
            print("vou mostrar o botao")
            signInButton.center = view.center
            view.addSubview(signInButton)
            print("apareceu")
            self.service.authorizer = nil
        } else {
            signInButton.isHidden = true
            signInDone = true
            stop()
            self.tableView.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        start()
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 20
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
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
                var eventDescription = (event.summary!).split(separator: ":")
                //var animalNameEvent = eventDescription[0]
                print("evento")
                print(eventDescription)
                print("------------")
                if eventDescription[0] == resultQrCode{
                    if qrCodeRead == true{
                        print("bora apagar")
                        let query = GTLRCalendarQuery_EventsDelete.query(withCalendarId: "primary", eventId: event.identifier!)
                        service.executeQuery(query, delegate: self, didFinish: nil)
                    }
                }
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
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let currentDate = formatter.string(from: Date())
        
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
            if String(currentDate) == String(date){
                dates.append(String(date))
                hoursTasks.append(time)
                animalsName.append(String(animalName))
                animalsTask.append(task)
            }
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
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stop(){
        activityIndicator.stopAnimating()
    }
}
