//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class AddUserViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var selectGroupButton: UIButton!
    var group: PFObject! = nil
    var menu: UIMenu = UIMenu()
    var db = Database()
    
    func callback(results: [AnyObject]?, err: Error? ) -> Void {
        var items: [UIAction] = [];
        for obj: AnyObject in results! {
            print(obj)
            let item = UIAction(title: obj["Name"] as! String) { (action) in
                self.group = (obj as! PFObject)
                self.selectGroupButton.setTitle(self.group["Name"] as! String, for: .normal)
            }
            items.append(item)
        }
        menu = UIMenu(title: "Pick a Group", image: nil, identifier: nil, options: [], children: items)
        selectGroupButton.menu = menu;
        selectGroupButton.showsMenuAsPrimaryAction = true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.text = "";
        addUserButton.layer.cornerRadius = 5;
        selectGroupButton.layer.cornerRadius = 5;
        var curr = PFUser.current();
        db.queryObjects(predicateStr: "Owner = '" + (curr?.username)! + "'", className: "Group", callback: callback(results:err:))
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
  
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "adminTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
    }
    
    @IBAction func addUser(_sender: UIButton) {
        if (group == nil || usernameField.text == nil) {
            let alert = UIAlertController(title:"Add User Error", message:"Please double check inputs", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated:true);
            return;
        }
        let spin = UIViewController.displaySpinner(onView: self.view)
        group.addUniqueObject(usernameField.text?.lowercased(), forKey: "Users")
        group.saveInBackground() { (user,error) in
            UIViewController.removeSpinner(spinner: spin)
            if user {
                self.usernameField.text = "";
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
