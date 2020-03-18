//
//  AlertsTableViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import EventKit

class AlertsTableViewController: UITableViewController {
    
    var db: Database!
    var tasks = [Todo]()
    var alerts = [[String: String]]()
    let eventStore = EKEventStore()
    var calendars = [EKCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database
        db = Database()
        
        calendars = eventStore.calendars(for: .event)
        
        loadTodos()
    }
    
    func loadTodos() {
        let uid = UserDefaults.standard.string(forKey: "uid")!
        
        self.db.getTodos(uid: uid, completion: { (todos, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tasks = todos!.sorted(by: { $0.due.isEarlier(from: $1.due) })
                self.handleSleepReminder()
                self.fetchEventsFromCalendar()
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! AlertCell
        
        let alert = alerts[indexPath.row]
        cell.typeLabel.text = alert["type"]
        cell.descriptionLabel.text = alert["description"]
        
        return cell
    }
    
    private func handleSleepReminder() {
        for task in tasks {
            if task.due.minutes(from: Date()) > 500 && task.due.minutes(from: Date()) < 2200 {
                alerts.append([
                    "type": "Sleep Reminder",
                    "description": "Make sure you sleep on time, you have tasks scheduled for tomorrow."
                ]);
                break;
            }
        }
    }
    
    private func handleCalendarEvents(event: EKEvent) {
        for task in tasks {
            let minutesToDue = task.due.minutes(from: Date())
            let minutesToEvent = event.startDate.minutes(from: Date())
            let eventDuration = event.endDate.minutes(from: event.startDate)
            
            if abs(minutesToDue - minutesToEvent) < eventDuration + 60 {
                alerts.append([
                    "type": "Calendar Event",
                    "description": "You have a calendar event \(event.title!), scheduled at time when your \(task.title) is due. Make sure you start working on \(task.title) early."
                ]);
            }
        }
    }
    
    private func fetchEventsFromCalendar() -> Void {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)

        switch (status) {
        case .notDetermined:
            requestAccessToCalendar()
        case .authorized:
            self.fetchEventsFromCalendar(calendarTitle: "Calendar")
            break
        case .restricted, .denied: break

        @unknown default:
            print("Error")
        }
    }

    private func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            self.fetchEventsFromCalendar(calendarTitle: "Calendar")
        }
    }

    // MARK: Fetech Events from Calendar
    
    private func fetchEventsFromCalendar(calendarTitle: String) -> Void {
        for calendar:EKCalendar in calendars {
            if calendar.title == calendarTitle {
                let selectedCalendar = calendar
                let startDate = NSDate(timeIntervalSinceNow: 0)
                let endDate = NSDate(timeIntervalSinceNow: 60*60*24*7)
                let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [selectedCalendar])
                let events = eventStore.events(matching: predicate) as [EKEvent]
                for event in events {
                    handleCalendarEvents(event: event)
                }
            }
        }
    }
}
