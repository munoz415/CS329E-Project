//
//  ViewController.swift
//  Volly

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class WelcomePage: UIViewController, UNUserNotificationCenterDelegate {
    
    var userType: String?
    var userName: String?
    @IBOutlet weak var topItem: UINavigationItem!
    
    var eventList: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UNUserNotificationCenter.current().delegate = self
        // Do any additional setup after loading the view.
        //print(userName!)
        
        //load events from core data into table
        EventsViewController().loadArr()
        
    
        
        
        let notification = UNMutableNotificationContent()
        notification.title = "Event is coming up!"
        notification.subtitle = "An event is happening in less than 24 hours."
        notification.body = "Get excited!"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // set up a request to tell iOS to submit the notification with that trigger
        let request = UNNotificationRequest(identifier: "notification1",
                                            content: notification,
                                            trigger: notificationTrigger)
        
        
        
        
        let fetchedResults = retrieveEvents()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        for event in fetchedResults {
            if let name = event.value(forKey:"name") {
                if let date = event.value(forKey:"date") {
                    if let eventDescription = event.value(forKey: "eventDescription") {
                        if let hours = event.value(forKey: "hours") {
                            if let location = event.value(forKey: "location") {
                                if let eventID = event.value(forKey: "eventID") {
                                    let eventItem = Event(name: name as! String, date: date as! String, hours: hours as! Double, location: location as! String, description: eventDescription as! String, eventID: eventID as! String)
                                    eventList.append(eventItem)
                                }
                            }
                        }
                    }
                }
            }
        }
        print("the events list count is \(eventList.count)")
        let currentDate = dateFormatter.string(from: Date())
        print("current date is \(currentDate)")
        for item in eventList {
            
            let date = dateFormatter.date(from: item.date)
            
            print(date)
            print("date difference is \(date?.timeIntervalSinceNow)")
            var timeDifference = date?.timeIntervalSinceNow
            if (timeDifference! / 3600 <= 24) {
                print("upcoming event")
                // submit the request to iOS
                UNUserNotificationCenter.current().add(request) { (error) in
                    print("Request error: \(error?.localizedDescription)",error?.localizedDescription as Any)
                }
                
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
    
    func retrieveEvents() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"EventEntity")
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = Theme.theme.background
        let results = retrieveSettings()
        if results.isEmpty == false{
            if let order = results.last?.value(forKey:"name") {
                //if let gradYear = results.last?.value(forKey:"gradYear"){
        topItem.title = "Welcome " + (order as! String) + "!"// + "(Class of " + (gradYear as! String) + ")!"
            //}
            }
        }
    }
    


}

