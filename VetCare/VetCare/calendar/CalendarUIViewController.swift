//
//  CalendarViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 03/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import MBCalendarKit

class CalendarUIViewController: CalendarViewController {
    
    var data : [Date:[CalendarEvent]] = [:]
    
    var dayTasks = [String]()
    var monthTasks = [String]()
    var yearTasks = [String]()
    var tasksNames = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        self.data = [:]
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.data = [:]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
        self.dataSource = self
        
        let defaults = UserDefaults.standard
        let calendarEvents = defaults.object(forKey: "eventsForCalendar") as? [String] ?? [String]()
        
        print(calendarEvents)
        
        for i in calendarEvents{
            //ex: 09/05/2018, 14:30 - hello: ghi
            print(i)
            var eventInfo = i.split(separator: "-")
            //09/05/2018, 14:30
            var timeInfo = eventInfo[0].trimmingCharacters(in: .whitespaces)
            //hello: ghi
            var taskInfo = eventInfo[1].trimmingCharacters(in: .whitespaces)
            var dateTime = timeInfo.split(separator: ",")
            //09/05/2018
            var date = dateTime[0]
            //var time = dateTime[1].trimmingCharacters(in: .whitespaces)
            var dateTypes = date.split(separator: "/")
            dayTasks.append(String(dateTypes[0]))
            monthTasks.append(String(dateTypes[1]))
            yearTasks.append(String(dateTypes[2]))
            tasksNames.append(taskInfo)
        }
        
        var counter = 0
        var lastDate = ""
        var dateFormatted = ""
        for i in tasksNames{
            let title : NSString = NSLocalizedString(tasksNames[counter], comment: "") as NSString
            if let date : Date = NSDate(day: UInt(dayTasks[counter])!, month: UInt(monthTasks[counter])!, year: 2018) as Date?
            {
                dateFormatted = dayTasks[counter] + "/" + monthTasks[counter] + "/" + "201ß"
                if String(dateFormatted) == String(lastDate){
                    let event : CalendarEvent = CalendarEvent(title: title as String, andDate: date, andInfo: nil)
                    self.data[date] = self.data[date]! + [event]
                }
                else{
                    let event : CalendarEvent = CalendarEvent(title: title as String, andDate: date, andInfo: nil)
                    self.data[date] = [event]
                }
                lastDate = dateFormatted
            }
            counter += 1
            if counter == tasksNames.count{
                counter = 0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Allows the data source to supply events to display on the calendar.
     
     @param calendarView The calendar view instance that will display the data.
     @param date The date for which the calendar view wants events.
     @return An array of events objects.
     */
    override func calendarView(_ calendarView: CalendarView, eventsFor date: Date) -> [CalendarEvent] {
        let eventsForDate = self.data[date] ?? []
        return eventsForDate
    }
    
    // MARK: - CKCalendarDelegate
    
    // Called before the selected date changes.
    override func calendarView(_ calendarView: CalendarView, didSelect date: Date) {
        super.calendarView(calendarView, didSelect: date) // Call super to ensure it
    }
    
    // Called after the selected date changes.
    override func calendarView(_ calendarView: CalendarView, willSelect date: Date) {
    }
    
    // A row was selected in the events table. (Use this to push a details view or whatever.)
    override func calendarView(_ calendarView: CalendarView, didSelect event: CalendarEvent) {
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
