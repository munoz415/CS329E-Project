//
//  SettingsViewController.swift
//  Volly

import UIKit
import CoreData
import AVFoundation

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIFontPickerViewControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController()
    var imageData: Data?
    @IBOutlet weak var gradYear: UITextField!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var gradYearLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var profilePictureLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var segControl: UISegmentedControl!
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
            UserDefaults.standard.set(true, forKey: "switchState")
            Theme.theme = DarkTheme()
            view.backgroundColor = Theme.theme.background
            profileName.textColor = Theme.theme.fontColor
            gradYearLabel.textColor = Theme.theme.fontColor
            fontLabel.textColor = Theme.theme.fontColor
            darkModeLabel.textColor = Theme.theme.fontColor
            profilePictureLabel.textColor = Theme.theme.fontColor
        }
        else{
            UserDefaults.standard.set(false, forKey: "switchState")
            UserDefaults.standard.set(1, forKey: "SegState")
            Theme.theme = LonghornTheme()
            view.backgroundColor = Theme.theme.background
            profileName.textColor = Theme.theme.fontColor
            gradYearLabel.textColor = Theme.theme.fontColor
            fontLabel.textColor = Theme.theme.fontColor
            darkModeLabel.textColor = Theme.theme.fontColor
            profilePictureLabel.textColor = Theme.theme.fontColor
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
        case 0:
            Theme.theme = LonghornTheme()
            UserDefaults.standard.set(1, forKey: "SegState")
            view.backgroundColor = Theme.theme.background
            profileName.textColor = Theme.theme.fontColor
            gradYearLabel.textColor = Theme.theme.fontColor
            fontLabel.textColor = Theme.theme.fontColor
            darkModeLabel.textColor = Theme.theme.fontColor
            profilePictureLabel.textColor = Theme.theme.fontColor
            profileName.font = UIFont(name: Theme.theme.font, size: profileName.font.pointSize)
            gradYearLabel.font = UIFont(name: Theme.theme.font, size: gradYearLabel.font.pointSize)
            fontLabel.font = UIFont(name: Theme.theme.font, size: fontLabel.font.pointSize)
            darkModeLabel.font = UIFont(name: Theme.theme.font, size: darkModeLabel.font.pointSize)
            profilePictureLabel.font = UIFont(name: Theme.theme.font, size: profilePictureLabel.font.pointSize)
        case 1:
            Theme.theme = CowboyTheme()
            view.backgroundColor = Theme.theme.background
            UserDefaults.standard.set(2, forKey: "SegState")
            profileName.textColor = Theme.theme.fontColor
            gradYearLabel.textColor = Theme.theme.fontColor
            fontLabel.textColor = Theme.theme.fontColor
            darkModeLabel.textColor = Theme.theme.fontColor
            profilePictureLabel.textColor = Theme.theme.fontColor
            profileName.font = UIFont(name: Theme.theme.font, size: profileName.font.pointSize)
            gradYearLabel.font = UIFont(name: Theme.theme.font, size: gradYearLabel.font.pointSize)
            fontLabel.font = UIFont(name: Theme.theme.font, size: fontLabel.font.pointSize)
            darkModeLabel.font = UIFont(name: Theme.theme.font, size: darkModeLabel.font.pointSize)
            profilePictureLabel.font = UIFont(name: Theme.theme.font, size: profilePictureLabel.font.pointSize)
        case 2:
            Theme.theme = OUTheme()
            view.backgroundColor = Theme.theme.background
            UserDefaults.standard.set(3, forKey: "SegState")
            profileName.textColor = Theme.theme.fontColor
            gradYearLabel.textColor = Theme.theme.fontColor
            fontLabel.textColor = Theme.theme.fontColor
            darkModeLabel.textColor = Theme.theme.fontColor
            profilePictureLabel.textColor = Theme.theme.fontColor
            profileName.font = UIFont(name: Theme.theme.font, size: profileName.font.pointSize)
            gradYearLabel.font = UIFont(name: Theme.theme.font, size: gradYearLabel.font.pointSize)
            fontLabel.font = UIFont(name: Theme.theme.font, size: fontLabel.font.pointSize)
            darkModeLabel.font = UIFont(name: Theme.theme.font, size: darkModeLabel.font.pointSize)
            profilePictureLabel.font = UIFont(name: Theme.theme.font, size: profilePictureLabel.font.pointSize)
        default:
            gradYearLabel.text = "This should never happen"
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
    
    @IBAction func cameraSelected(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) {
                    accessGranted in
                    guard accessGranted == true else { return }
                }
            case .authorized:
                break
            default:
                print("Access denied")
                return
            }
            
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            
            present(picker, animated: true, completion: nil)
        
        } else {
            
            let alertVC = UIAlertController(
                title: "No camera",
                message: "Please select Choose Picture Instead",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
            
        }
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.theme.background
        profileName.textColor = Theme.theme.fontColor
        gradYearLabel.textColor = Theme.theme.fontColor
        fontLabel.textColor = Theme.theme.fontColor
        darkModeLabel.textColor = Theme.theme.fontColor
        profilePictureLabel.textColor = Theme.theme.fontColor
        profileName.font = UIFont(name: Theme.theme.font, size: profileName.font.pointSize)
        gradYearLabel.font = UIFont(name: Theme.theme.font, size: gradYearLabel.font.pointSize)
        fontLabel.font = UIFont(name: Theme.theme.font, size: fontLabel.font.pointSize)
        darkModeLabel.font = UIFont(name: Theme.theme.font, size: darkModeLabel.font.pointSize)
        profilePictureLabel.font = UIFont(name: Theme.theme.font, size: profilePictureLabel.font.pointSize)
        switchButton.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        
    }
   
}
