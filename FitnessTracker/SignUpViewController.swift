//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpUsernameField: UITextField!
    @IBOutlet weak var signUpPasswordField: UITextField!
    @IBOutlet weak var signUpEmailField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpUsernameField.text = ""
        signUpPasswordField.text = ""
        signUpEmailField.text = ""
        signUpButton.layer.cornerRadius = 5;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeView();
        }
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "adminTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    @IBAction func signUp(_sender: UIButton) {
        let spin = UIViewController.displaySpinner(onView: self.view)
        let user = PFUser();
        user.username = signUpUsernameField.text?.lowercased();
        user.password = signUpPasswordField.text;
        user.email = signUpEmailField.text;
        user.signUpInBackground { (user,error) in
            UIViewController.removeSpinner(spinner: spin)
            if let error = error {
                let alert = UIAlertController(title:"Account Error", message:error.localizedDescription, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated:true);
            } else {
                self.loadHomeView();
            }
            
        }
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
