//
//  ViewController.swift
//  Volly

import UIKit
import Firebase
import FirebaseAuth

class WelcomePage: UIViewController {
    
    var userType: String?
    var userName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test")
        // Do any additional setup after loading the view.
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
    }

}

