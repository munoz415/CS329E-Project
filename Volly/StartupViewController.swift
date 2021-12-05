//
//  StartupViewController.swift
//  Volly

import UIKit
import CoreData

class StartupViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //center imageview
        imageView.center = view.center
        //execute animation after short delay
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        //fade the image away
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }, completion: { done in
            if done {
                //after a delay, segue into the login controller
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                })
            }
            
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: "switchState") == true{
            Theme.theme = DarkTheme()
        }
        else{
            if UserDefaults.standard.integer(forKey: "SegState") == 1{
                Theme.theme = LonghornTheme()
            }
            else if UserDefaults.standard.integer(forKey: "SegState") == 2{
                Theme.theme = CowboyTheme()
            }
            else if UserDefaults.standard.integer(forKey: "SegState") == 3{
                Theme.theme = OUTheme()
            }
            else{
                Theme.theme = LonghornTheme()
            }
            
        }
        view.backgroundColor = Theme.theme.background
        
    }
}
