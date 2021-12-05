//
//  AddEventViewController.swift
//  Volly

import UIKit
import CoreData
import CoreHaptics
import EventKit

protocol plusLocation {
    //function to add new location event
    func addLocation(newLocation:String)
}

class AddEventViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var hoursField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var currentEvent = Event()
    
    let segueIdentifier = "mapSegueIdentifier"
    
    var engine: CHHapticEngine!
    
    let eventStore = EKEventStore()
    
    var rawDate = NSDate()
    
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set specific date and time mode
        datePicker.datePickerMode = .dateAndTime
        
        //test if haptic is supported on the device
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        //make date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: sender.date)
        rawDate = datePicker.date as NSDate
        
        //add date string to event object
        currentEvent.setDate(newDate: dateString)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //if all fields have been filled in
        if(nameField.text != "" && hoursField.text != "" && descriptionField.text != "") {
            //set event object attributes from respective fields
            currentEvent.setName(newName: nameField.text!)
            currentEvent.setHours(newHours: Double(hoursField.text!)!)
            currentEvent.setDescription(newDescription: descriptionField.text!)
            
            //if the user does not unput a date, use current time
            if (currentEvent.date == "") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let dateString = dateFormatter.string(from: Date())
                print("**********TODAY IS: \(dateString)")
                rawDate = datePicker.date as NSDate
                currentEvent.setDate(newDate: dateString)
            }
            
            //if the user does not input a location, use the name of the event
            if(currentEvent.location == "") {
                currentEvent.setLocation(newLocation: nameField.text!)
            }
            
            //put event in calendar
            addToCalendar()
            
            //store event in core data
            storeEvent()
            
            //load events from core data into table
            EventsViewController().loadArr()
            
            //create and execute haptic response
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
                    
            do {
              let pattern = try CHHapticPattern(events: [event], parameters: [])
              let player = try engine?.makePlayer(with: pattern)
              try player?.start(atTime: CHHapticTimeImmediate)
            } catch {
                print("There was an error with the haptics: \(error.localizedDescription)")
            }
        } else {
            //if there is an empty field
            let missingField = currentEvent.fullEvent()
            //create controller to display alert of missing field
            let controller = UIAlertController(title: "Missing entry", message: "Please fill in \(missingField)", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
        
        //show notification that event was saved
        let controller = UIAlertController(title: "Event saved successfully!", message: "\(currentEvent.name) has been saved successfully", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
        
    }
    
    func addToCalendar() {
        let startDate = rawDate
        let endDate = startDate.addingTimeInterval(60*60*currentEvent.hours)
        
        if(EKEventStore.authorizationStatus(for: .event) != .authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(title: self.currentEvent.name, startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(title: self.currentEvent.name, startDate: startDate, endDate: endDate)
        }
    }
    
    func createEvent(title: String, startDate:NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate as Date?
        event.endDate = endDate as Date?
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            // save the event to the calendar
            try eventStore.save(event, span: .thisEvent)
            
            // save the identifier so we can delete the event later
            currentEvent.setEventID(newEventID: event.eventIdentifier)
        } catch {
            print("Error")
        }
    }
    
    func storeEvent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //create new event entity
        let event = NSEntityDescription.insertNewObject(
            forEntityName: "EventEntity", into: context)
        
        // Set attribute values
        event.setValue(currentEvent.name, forKey: "name")
        event.setValue(currentEvent.date, forKey: "date")
        event.setValue(currentEvent.description, forKey: "eventDescription")
        event.setValue(currentEvent.hours, forKey: "hours")
        event.setValue(currentEvent.location, forKey: "location")
        event.setValue(currentEvent.eventID, forKey: "eventID")
        
        // Commit the changes
        do {
            try context.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if going to the map page
        if segue.identifier == segueIdentifier,
           let nextVC = segue.destination as? MapViewController {
            //delegate self
            nextVC.delegate = self
            nextVC.eventName = nameField.text!
            nextVC.hours = hoursField.text!
        }
    }
    
    func plusLocation(newLocation:String) {
        currentEvent.setLocation(newLocation: newLocation)
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            view.backgroundColor = Theme.theme.background
            nameLabel.textColor = Theme.theme.fontColor
            hourLabel.textColor = Theme.theme.fontColor
            dataLabel.textColor = Theme.theme.fontColor
            locationLabel.textColor = Theme.theme.fontColor
            descriptionLabel.textColor = Theme.theme.fontColor
            nameLabel.font = UIFont(name: Theme.theme.font, size: nameLabel.font.pointSize)
            hourLabel.font = UIFont(name: Theme.theme.font, size: hourLabel.font.pointSize)
            dataLabel.font = UIFont(name: Theme.theme.font, size: dataLabel.font.pointSize)
            locationLabel.font = UIFont(name: Theme.theme.font, size: locationLabel.font.pointSize)
            descriptionLabel.font = UIFont(name: Theme.theme.font, size: descriptionLabel.font.pointSize)
        //datePicker.setValue(Theme.theme.fontColor, forKey: "textColor")
        
        
    }

}
