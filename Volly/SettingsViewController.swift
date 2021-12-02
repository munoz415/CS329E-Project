//
//  SettingsViewController.swift
//  Volly

import UIKit
import CoreData

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIFontPickerViewControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController()
    var imageData: Data?
    @IBOutlet weak var gradYear: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let results = retrieveSettings()
        if results.isEmpty == false{
            //print("ran 1")
            if let order = results.last?.value(forKey:"imageData") {
                //print("ran2")
                let image = UIImage(data: order as! Data)
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchHappened(_ sender: UISwitch) {
        if sender.isOn{
            Theme.theme = DarkTheme()
            view.backgroundColor = Theme.theme.background
        }
        else{
            Theme.theme = LightTheme()
            view.backgroundColor = Theme.theme.background
        }
    }
    
    @IBAction func pictureButtonpressed(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // "info" contains a dictionary of information about the selected media, including:
        // - metadata
        // - a user-edited image (if we set the allowsEditing property to true)
        
        let chosenImage = info[.originalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        let imageData = chosenImage.jpegData(compressionQuality: 1.0)
        self.imageData = imageData
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func fontButtonPressed(_ sender: Any) {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        let vc = UIFontPickerViewController(configuration: config)
        vc.delegate = self
        present(vc,animated: true)
    }
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        }
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        let font = viewController.selectedFontDescriptor
        print(font)
        }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if(nameField.text != nil) {
            //store Settings in core data
            storeSettings()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        
        
    func storeSettings() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //create new event entity
            let settingValues = NSEntityDescription.insertNewObject(
                forEntityName: "SettingsEntity", into: context)
            // Set attribute values
        
            settingValues.setValue(nameField.text, forKey: "name")
            settingValues.setValue(imageData, forKey: "imageData")
        settingValues.setValue(gradYear.text, forKey: "grad")
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
    func retrieveSettings() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"SettingsEntity")
        var fetchedResults:[NSManagedObject]? = nil
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return(fetchedResults)!
        
    }
   
}
