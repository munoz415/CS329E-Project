//
//  LoginViewController.swift
//  Volly

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UILabel!
    let segueIdentifier = "loginToWelcome"
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var passwordText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if (emailTextField.text != "") && (passwordTextField.text != "") {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            // check that email follows either user or admin structure
            // user email structure is ___@user.com
            // admin email structure is ___@admin.com
            if (email.suffix(9) == "@user.com") || (email.suffix(10) == "@admin.com") {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        let controller = UIAlertController(
                            title: "Invalid email",
                            message: "Try again with a valid email",
                            preferredStyle: .alert)
                        controller.addAction(UIAlertAction(
                                                title: "OK",
                                                style: .default,
                                                handler: nil))
                        self.present(controller, animated: true, completion: nil)
                        
                    } else {
                        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
                    }
                    
                }
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
                print("Check")
                nextVC.userType = "Admin"
                if let i = emailTextField.text!.firstIndex(of: "@") {
                    let index: Int = emailTextField.text!.distance(from: emailTextField.text!.startIndex, to: i)
                    let name = emailTextField.text!.prefix(index)
                    nextVC.userName = String(name)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = Theme.theme.background
        LoginButton.textColor = Theme.theme.fontColor
        passwordText.textColor = Theme.theme.fontColor
        emailText.textColor = Theme.theme.fontColor
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
