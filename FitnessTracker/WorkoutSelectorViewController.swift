//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class WorkoutSelectorViewController: UIViewController {

    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var liftButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        runButton.layer.cornerRadius = 5;
        liftButton.layer.cornerRadius = 5;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "User", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "userTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    @IBAction func run(_sender: UIButton) {
        let story: UIStoryboard = UIStoryboard(name: "GroupLeader", bundle: nil)
        let signUpView = story.instantiateViewController(identifier: "AssignRunViewController") as! AssignRunViewController
        self.present(signUpView, animated:true, completion: nil)
    }
    
    @IBAction func lift(_sender: UIButton) {
        let story: UIStoryboard = UIStoryboard(name: "GroupLeader", bundle: nil)
        let signUpView = story.instantiateViewController(identifier: "AssignLiftViewController") as! AssignLiftViewController
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
