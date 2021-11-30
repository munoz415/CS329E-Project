//
//  ViewController.swift
//  Volly

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class WelcomePage: UIViewController {
    
    var userType: String?
    var userName: String?
    @IBOutlet weak var topItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(userName!)
        let results = retrieveSettings()
        if results.isEmpty == false{
            if let order = results.last?.value(forKey:"name") {
        topItem.title = topItem.title! + " " + (order as! String) + "!"
            }
        }
    }
        
    

    @IBAction func logOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "welcomeLoggedOut", sender: self)
            //navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addEvents",
           let nextVC = segue.destination as? AddEventViewController{
            //delegate self
            //nextVC.delegate = self
           
        }
        if segue.identifier == "events",
           let nextVC = segue.destination as? EventsViewController{
            //delegate self
            //nextVC.delegate = self
        }
        if segue.identifier == "welcomeLoggedOut" {
            let nextVC = segue.destination as? LoginViewController
        }
        if segue.identifier == "settingsPage" {
            let nextVC = segue.destination as? SettingsViewController
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

