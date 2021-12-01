//
//  EventsViewController.swift
//  Volly

import UIKit
import CoreData
import EventKit

class tableCell: UITableViewCell {
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var eventList:[Event] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "EventCell"
    
    var delegate: UIViewController!
    
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70.0
        tableView.delegate = self
        tableView.dataSource = self
        loadArr()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func retrieveEvent() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"EventEntity")
        var fetchedResults:[NSManagedObject]? = nil

        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
//            self.eventList = fetchedResults!
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
        catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        return(fetchedResults)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! tableCell
        let row = indexPath.row
        //set num of lines to zero so entire description appears in the cell
        //cell.textLabel?.numberOfLines = 0
        //fill cell with description of event from list
        cell.eventLabel?.text = eventList[row].name
        cell.dateLabel?.text = eventList[row].date
        cell.hoursLabel?.text = String(eventList[row].hours)
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //remove event from calendar
            removeEventSelected(selectedEvent: eventList[indexPath.row])
            //remove event from event array
            eventList.remove(at: indexPath.row)
            //remove event from core data
            deleteEvent(idx: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func removeEventSelected(selectedEvent: Event) {
        if(EKEventStore.authorizationStatus(for: .event) != .authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.deleteCalEvent(eventIdentifier: selectedEvent.eventID)
            })
        } else {
            deleteCalEvent(eventIdentifier: selectedEvent.eventID)
        }
    }
    
    func deleteCalEvent(eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if(eventToRemove != nil) {
            do{
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("Error")
            }
        }
    }
    
    func deleteEvent(idx: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                //delete pizza at specific index
                context.delete(fetchedResults[idx])
            }
            try context.save()
            
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

    }
    
    func loadArr() {
        //get pizzas from core data
        let fetchedResults = retrieveEvent()
        
        //for each event, get attributes and add a new pizza object to pizza list
        for event in fetchedResults {
            if let eventName = event.value(forKey: "name") {
                if let eventDate = event.value(forKey: "date") {
                    if let eventHours = event.value(forKey: "hours") {
                        if let eventLocation = event.value(forKey: "location") {
                            if let eventDescription = event.value(forKey: "eventDescription") {
                                if let eventID = event.value(forKey: "eventID") {
                                    var newEvent = Event(name: eventName as! String, date: eventDate as! String, hours: eventHours as! Double, location: eventLocation as! String, description: eventDescription as! String, eventID: eventID as! String)
                                    eventList.append(newEvent)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addEvent(newEvent: Event) {
        //add new event object to list of event
        eventList.append(newEvent)
        //update table with new event
        tableView.reloadData()
    }
}
