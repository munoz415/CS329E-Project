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
    @IBOutlet weak var hourLabel2: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
}

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var eventList:[Event] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "EventCell"
    
    var delegate: UIViewController!
    
    let mapSegueID = "eventMapSegue"
    
    var selectedRow = 0
    
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70.0
        tableView.delegate = self
        tableView.dataSource = self
        loadArr()
    }
    
    //set the number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    //get events from core data
    func retrieveEvent() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"EventEntity")
        var fetchedResults:[NSManagedObject]? = nil

        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
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
        //fill cell with description of event from list
        cell.eventLabel?.text = eventList[row].name
        cell.dateLabel?.text = eventList[row].date
        cell.hoursLabel?.text = String(eventList[row].hours)
        cell.eventLabel?.textColor = Theme.theme.fontColor
        cell.dateLabel?.textColor = Theme.theme.fontColor
        cell.hoursLabel?.textColor = Theme.theme.fontColor
        cell.eventLabel2?.textColor = Theme.theme.fontColor
        cell.dateLabel2?.textColor = Theme.theme.fontColor
        cell.hourLabel2?.textColor = Theme.theme.fontColor
        cell.eventLabel?.font = UIFont(name: Theme.theme.font, size: cell.eventLabel.font.pointSize)
        cell.dateLabel?.font = UIFont(name: Theme.theme.font, size: cell.dateLabel.font.pointSize)
        cell.hoursLabel?.font = UIFont(name: Theme.theme.font, size: cell.hoursLabel.font.pointSize)
        cell.eventLabel2?.font = UIFont(name: Theme.theme.font, size: cell.eventLabel2.font.pointSize)
        cell.dateLabel2?.font = UIFont(name: Theme.theme.font, size: cell.dateLabel2.font.pointSize)
        cell.hourLabel2?.font = UIFont(name: Theme.theme.font, size: cell.hourLabel2.font.pointSize)
        cell.backgroundColor = Theme.theme.background
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
            //delete row from table
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mapSegueID,
           //if going to the map page
           let nextVC = segue.destination as? EventMapViewController {
            //delegate self
            nextVC.delegate = self
            //get selected row from table
            self.selectedRow = tableView.indexPath(for: sender as! tableCell)!.row
            //send event to other vc
            nextVC.event = eventList[self.selectedRow]
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
                //delete event at specific index
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
        //get event from core data
        let fetchedResults = retrieveEvent()
        
        //for each event, get attributes and add a new event object to event list
        for event in fetchedResults {
            if let name = event.value(forKey:"name") {
                if let date = event.value(forKey:"date") {
                    if let eventDescription = event.value(forKey: "eventDescription") {
                        if let hours = event.value(forKey: "hours") {
                            if let latitude = event.value(forKey: "eventLat") {
                                if let longitude = event.value(forKey: "eventLon") {
                                    if let eventID = event.value(forKey: "eventID") {
                                        let eventItem = Event(name: name as! String, date: date as! String, hours: hours as! Double, eventLatitude: latitude as! Double, eventLongitude: longitude as! Double, description: eventDescription as! String, eventID: eventID as! String)
                                        eventList.append(eventItem)
                                    }
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
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            view.backgroundColor = Theme.theme.background
        tableView.backgroundColor = Theme.theme.background
        //datePicker.setValue(Theme.theme.fontColor, forKey: "textColor")
        
        
    }
}
