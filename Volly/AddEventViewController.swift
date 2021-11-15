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
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if(nameField.text != nil && hoursField != nil && descriptionField != nil) {
            currentEvent.setName(newName: nameField.text!)
            currentEvent.setHours(newHours: Double(hoursField.text!)!)
            currentEvent.setDescription(newDescription: descriptionField.text!)
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
