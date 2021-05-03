//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var signInUsernameField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        signInUsernameField.text = ""
        signInPasswordField.text = ""
        signUpButton.layer.cornerRadius = 5;
        loginButton.layer.cornerRadius = 5;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeView();
        }
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "User", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "userTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    @IBAction func signIn(_sender: UIButton) {
        let spin = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: signInUsernameField.text!.lowercased(), password: signInPasswordField.text!) { (user,error) in
            UIViewController.removeSpinner(spinner: spin)
            if user != nil {
                self.loadHomeView();
            } else {
                print(error?.localizedDescription)
            }
            
        }
    }
    
    @IBAction func signUp(_sender: UIButton) {
        let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpView = story.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpView, animated:true, completion: nil)
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
