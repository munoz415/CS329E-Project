//
//  PastEventsViewController.swift
//  Volly

import UIKit
import CoreData

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var eventList:[NSManagedObject] = []
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        UNUserNotificationCenter.current().delegate = self
        
        let fetchedResults = retrieveEvent()
        for event in fetchedResults {
            if let dateString = event.value(forKey:"date") {
                print("date String is \(dateString as! String)")
            }
        }

        // Do any additional setup after loading the view.
        
        // checking to see if eventsList number matches with number fetched
        var eventCount = 0
        var fetchedCount = 0
        for i in eventList {
            eventCount += 1
        }
        for j in fetchedResults {
            fetchedCount += 1
        }
        print(eventCount, fetchedCount)
    }
    
    func retrieveEvent() -> [NSManagedObject] {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"EventEntity")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
            self.eventList = fetchedResults!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return(fetchedResults)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let eventRow = eventList[indexPath.row]
        cell.textLabel?.text =  "\(String(describing: eventRow.value(forKey: "name"))) " +
                                "\(String(describing: eventRow.value(forKey: "date"))) \n" +
                                "\(String(describing: eventRow.value(forKey: "eventDescription"))) \n" +
                                "\(String(describing: eventRow.value(forKey: "hours"))) \n" +
                                "\(String(describing: eventRow.value(forKey: "location"))) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count * 6
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionhandler) in
            
            // Which event to remove
            let eventToRemove = self.eventList[indexPath.row]
            
            // remove event
            self.context.delete(eventToRemove)
            
            // save the data
            do {
                try self.context.save()
            }
            catch {
            }
            
            self.eventList = self.retrieveEvent()
            }
        
        return UISwipeActionsConfiguration(actions: [action])
        }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
