//
//  ViewController.swift
//  FitnessTracker
//
//  Created by Chris on 3/23/21.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet fileprivate var signInUsernameField: UITextField!
    @IBOutlet fileprivate var signInPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_sender: UIButton) {
        let spin = UIViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: spin)
            if (error == nil) {
                let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let view = story.instantiateViewController(identifier: "LogInViewController") as! LogInViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(view)
            } else {
                print(error?.localizedDescription)
            }
        }
    }


}

