//
//  SettingsViewController.swift
//  Volly

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if(nameField.text != nil) {
            //store Settings in core data
            storeSettings()
    }
    
        func storeSettings() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //create new event entity
            let settingValues = NSEntityDescription.insertNewObject(
                forEntityName: "SettingsEntity", into: context)
            
            // Set attribute values
            settingValues.setValue(nameField.text, forKey: "name")
            
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

}
   
}
