//
//  AddEventViewController.swift
//  Volly

import UIKit
import CoreData

protocol plusLocation {
    //function to add new pizza to list
    func addLocation(newLocation:String)
}

class AddEventViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var hoursField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextField!
    
    var currentEvent = Event()
    
    let segueIdentifier = "mapSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        datePicker.datePickerMode = .dateAndTime
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        let dateString = dateFormatter.string(from: sender.date)
        
        currentEvent.setDate(newDate: dateString)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if(nameField.text != nil && hoursField != nil && descriptionField != nil) {
            currentEvent.setName(newName: nameField.text!)
            currentEvent.setHours(newHours: Double(hoursField.text!)!)
            currentEvent.setDescription(newDescription: descriptionField.text!)
            
            storeEvent()
        } else {
            let missingField = currentEvent.fullEvent()
            //create controller to display alert of missing ingredient
            let controller = UIAlertController(title: "Missing entry", message: "Please fill in \(missingField)", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
    }
    
    func storeEvent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //get event from pizza event
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
        //if going to the create page
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
