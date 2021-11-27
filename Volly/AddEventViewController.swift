//
//  AddEventViewController.swift
//  Volly

import UIKit
import CoreData
import CoreHaptics

protocol plusLocation {
    //function to add new location event
    func addLocation(newLocation:String)
}

class AddEventViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var hoursField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextField!
    
    var currentEvent = Event()
    
    let segueIdentifier = "mapSegueIdentifier"
    
    var engine: CHHapticEngine!
    
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
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        let dateString = dateFormatter.string(from: sender.date)
        
        //add date string to event object
        currentEvent.setDate(newDate: dateString)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //if all fields have been filled in
        if(nameField.text != nil && hoursField != nil && descriptionField != nil) {
            //set event object attributes from respective fields
            currentEvent.setName(newName: nameField.text!)
            currentEvent.setHours(newHours: Double(hoursField.text!)!)
            currentEvent.setDescription(newDescription: descriptionField.text!)
            
            //store event in core data
            storeEvent()
            
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

}
