//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class AddWorkoutViewController: UIViewController {

    @IBOutlet weak var workoutNameField: UITextField!
    @IBOutlet weak var createWorkoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutNameField.text = "";
        createWorkoutButton.layer.cornerRadius = 5;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "adminTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    @IBAction func addWorkout(_sender: UIButton) {
        let spin = UIViewController.displaySpinner(onView: self.view)
        let workout = PFObject(className: "AvailableWorkout");
        workout["Name"] = workoutNameField.text;
        workout.saveInBackground() { (user,error) in
            UIViewController.removeSpinner(spinner: spin)
            if user {
                self.workoutNameField.text = "";
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
