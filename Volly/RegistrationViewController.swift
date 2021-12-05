//
//  RegistrationViewController.swift
//  Volly
//
//  Created by Khoa Ho on 11/9/21.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    let segueIdentifier = "registerToWelcome"
    
    //var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { auth, user in
//              // [START_EXCLUDE]
//              self.setTitleDisplay(user)
//              self.tableView.reloadData()
//              // [END_EXCLUDE]
//            }
//    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if (emailTextField.text != "") && (passwordTextField.text != "") {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            // check that email follows either user or admin structure
            // user email structure is ___@user.com
            // admin email structure is ___@admin.com
            if (email.count > 9) {
                if (email.suffix(9) == "@user.com") || (email.suffix(10) == "@admin.com") {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error {
                            let controller = UIAlertController(
                                title: "Invalid email structure",
                                message: "Try again with a valid email structure",
                                preferredStyle: .alert)
                            controller.addAction(UIAlertAction(
                                                    title: "OK",
                                                    style: .default,
                                                    handler: nil))
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            self.performSegue(withIdentifier: "registerToWelcome", sender: self)
                        }
                        
                    }
                }
            } else {
                let controller = UIAlertController(
                    title: "Invalid email structure",
                    message: "Try again with a valid email structure",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                                        title: "OK",
                                        style: .default,
                                        handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        } else {
            let controller = UIAlertController(
                title: "Empty Text Fields",
                message: "Fill out both of the email and password text fields.",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                                    title: "OK",
                                    style: .default,
                                    handler: nil))
            present(controller, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // comma in if structure means both conditions need to be true
        // nextVC needs to be possible to create before going into if instructions
        if segue.identifier == segueIdentifier, let nextVC = segue.destination as? WelcomePage {
            // setting the delegate for nextVC as this ViewController
            // gives us a pointer to this view controller from the second view controller
            if (emailTextField.text!.suffix(9) == "@user.com") {
                nextVC.userType = "User"
                if let i = emailTextField.text!.firstIndex(of: "@") {
                    let index: Int = emailTextField.text!.distance(from: emailTextField.text!.startIndex, to: i)
                    let name = emailTextField.text!.prefix(index)
                    nextVC.userName = String(name)
                }
            } else if (emailTextField.text!.suffix(10) == "@admin.com") {
                nextVC.userType = "Admin"
                if let i = emailTextField.text!.firstIndex(of: "@") {
                    let index: Int = emailTextField.text!.distance(from: emailTextField.text!.startIndex, to: i)
                    let name = emailTextField.text!.prefix(index)
                    nextVC.userName = String(name)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.theme.background
        registerLabel.textColor = Theme.theme.fontColor
        emailLabel.textColor = Theme.theme.fontColor
        passwordLabel.textColor = Theme.theme.fontColor
        registerLabel.font = UIFont(name: Theme.theme.font, size: registerLabel.font.pointSize)
        emailLabel.font = UIFont(name: Theme.theme.font, size: emailLabel.font.pointSize)
        passwordLabel.font = UIFont(name: Theme.theme.font, size: passwordLabel.font.pointSize)
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
