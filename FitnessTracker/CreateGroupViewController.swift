//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var groupLeaderField: UITextField!
    @IBOutlet weak var createGroupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameField.text = "";
        groupLeaderField.text = "";
        createGroupButton.layer.cornerRadius = 5;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "adminTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    @IBAction func createGroup(_sender: UIButton) {
        let spin = UIViewController.displaySpinner(onView: self.view)
        let group = PFObject(className: "Group");
        group["Name"] = groupNameField.text;
        group["Owner"] = groupLeaderField.text?.lowercased();
        group["Users"] = [];
        group.saveInBackground() { (user,error) in
            UIViewController.removeSpinner(spinner: spin)
            if user {
                self.loadHomeView();
            } else {
                print(error?.localizedDescription)
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
