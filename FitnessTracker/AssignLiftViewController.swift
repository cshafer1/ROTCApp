//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class AssignLiftViewController: UIViewController {

    @IBOutlet weak var lengthField: UITextField!
    @IBOutlet weak var assignWorkoutButton: UIButton!
    @IBOutlet weak var selectGroupButton: UIButton!
    @IBOutlet weak var selectUserButton: UIButton!
    @IBOutlet weak var selectWorkoutButton: UIButton!
    var group: PFObject! = nil
    var user: PFObject! = nil
    var userMenu: UIMenu = UIMenu()
    var menu: UIMenu = UIMenu()
    var workoutMenu: UIMenu = UIMenu()
    var db = Database()
    
    func userCallback(results: [AnyObject]?, err:Error?) -> Void {
        var items: [UIAction] = [];
        print(err?.localizedDescription)
        for obj: AnyObject in results! {
            print(obj)
            let item = UIAction(title: obj["username"] as! String) { (action) in
                self.user = (obj as! PFObject)
                self.selectUserButton.setTitle(self.user["username"] as! String, for: .normal)

            }
            items.append(item)
        }
        userMenu = UIMenu(title: "Pick a User", image: nil, identifier: nil, options: [], children: items)
        selectUserButton.menu = userMenu;
        selectUserButton.showsMenuAsPrimaryAction = true;
        selectUserButton.isEnabled = true;
    }
    
    func callback(results: [AnyObject]?, err: Error? ) -> Void {
        var items: [UIAction] = [];
        for obj: AnyObject in results! {
            print(obj)
            let item = UIAction(title: obj["Name"] as! String) { (action) in
                self.group = (obj as! PFObject)
                self.selectGroupButton.setTitle(self.group["Name"] as! String, for: .normal)
                let userArr: [String] = self.group["Users"] as! [String]
                var query = PFUser.query();
                
                query!.whereKey("username", containedIn: userArr);
                query!.findObjectsInBackground() { (results: [PFObject]?, err:Error?) in
                    var items: [UIAction] = [];
                    print(err?.localizedDescription)
                    for obj: PFObject in results! {
                        print(obj)
                        let item = UIAction(title: obj["username"] as! String) { (action) in
                            self.user = (obj as! PFObject)
                            self.selectUserButton.setTitle(self.user["username"] as! String, for: .normal)

                        }
                        items.append(item)
                    }
                    self.userMenu = UIMenu(title: "Pick a User", image: nil, identifier: nil, options: [], children: items)
                    self.selectUserButton.menu = self.userMenu;
                    self.selectUserButton.showsMenuAsPrimaryAction = true;
                    self.selectUserButton.isEnabled = true;
                }
                //self.db.queryObjects(predicateStr: "username IN " + userStr, className: "User", callback: self.userCallback(results:err:))
            }
            items.append(item)
        }
        menu = UIMenu(title: "Pick a Group", image: nil, identifier: nil, options: [], children: items)
        selectGroupButton.menu = menu;
        selectGroupButton.showsMenuAsPrimaryAction = true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectUserButton.layer.cornerRadius = 5;
        assignWorkoutButton.layer.cornerRadius = 5;
        selectGroupButton.layer.cornerRadius = 5;
        selectWorkoutButton.layer.cornerRadius = 5;
        selectUserButton.isEnabled = false;
        var curr = PFUser.current();
        db.queryObjects(predicateStr: "Owner = '" + (curr?.username)! + "'", className: "Group", callback: callback(results:err:))
        let query = PFQuery(className: "AvailableWorkout")
        query.findObjectsInBackground() { (results: [PFObject]?, err:Error?) in
            var items: [UIAction] = [];
            print(err?.localizedDescription)
            for obj: PFObject in results! {
                print(obj)
                let item = UIAction(title: obj["Name"] as! String) { (action) in
                    self.selectWorkoutButton.setTitle(obj["Name"] as! String, for: .normal)

                }
                items.append(item)
            }
            self.workoutMenu = UIMenu(title: "Pick a Workout", image: nil, identifier: nil, options: [], children: items)
            self.selectWorkoutButton.menu = self.workoutMenu;
            self.selectWorkoutButton.showsMenuAsPrimaryAction = true;
            self.selectWorkoutButton.isEnabled = true;
            
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
  
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "adminTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    func assignRunCallback(obj: PFObject?, err:Error?){
        var temp = obj;
        if((temp) == nil) {
            temp = PFObject(className: "Runs")
            temp!["netid"] = user["username"]
            temp!["workout"] = [selectWorkoutButton.currentTitle! + " " + lengthField.text!]
        }
        temp?.addObjects(from: [selectWorkoutButton.currentTitle! + " " + lengthField.text!], forKey: "workout")
        temp?.saveInBackground();
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func assignRun(_sender: UIButton) {
        if (group == nil || lengthField.text == nil || user == nil || selectWorkoutButton.currentTitle == "Workout") {
            let alert = UIAlertController(title:"Add User Error", message:"Please double check inputs", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated:true);
            return;
        }
        let spin = UIViewController.displaySpinner(onView: self.view)
        let name = user["username"] as! String;
        db.queryFirstObject(predicateStr: "netid == '"+name+"'", className: "Workouts", callback: assignRunCallback(obj:err:))
        UIViewController.removeSpinner(spinner: spin)
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
