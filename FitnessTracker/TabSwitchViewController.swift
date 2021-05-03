//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class TabSwitchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.current();
        let perms:Int = currentUser!["permission"] as! Int;
        let stackView = UIStackView(frame:CGRect(x:0, y:100, width: 400, height: 200))
        stackView.backgroundColor = self.view.backgroundColor;
        stackView.axis = NSLayoutConstraint.Axis.vertical;
        stackView.distribution = UIStackView.Distribution.equalSpacing;
        stackView.alignment = UIStackView.Alignment.center;
        stackView.spacing = 16.0;

        
        if(perms > 1) {
            let btn = UIButton();
            btn.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
            btn.setTitle("Admin Tab", for: .normal);
            btn.setTitleColor(UIColor.white, for: .normal);
            btn.addTarget(self, action: #selector(self.adminButton), for: .touchUpInside);
            btn.frame = CGRect(x:20, y:20, width:200, height:30);
            btn.layer.cornerRadius = 5;
            btn.widthAnchor.constraint(equalToConstant: 200).isActive = true;
            stackView.addArrangedSubview(btn);
        }
        if(perms > 0) {
            let btn = UIButton();
            btn.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
            btn.setTitle("Group Manager Tab", for: .normal);
            btn.setTitleColor(UIColor.white, for: .normal);
            btn.addTarget(self, action: #selector(self.groupButton), for: .touchUpInside);
            btn.frame = CGRect(x:20, y:20, width:200, height:30);
            btn.layer.cornerRadius = 5;
            btn.widthAnchor.constraint(equalToConstant: 200).isActive = true;
            stackView.addArrangedSubview(btn);
        }
        

        let btn = UIButton();
        btn.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
        btn.setTitle("User Tab", for: .normal);
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.addTarget(self, action: #selector(self.userButton), for: .touchUpInside);
        btn.frame = CGRect(x:20, y:20, width:200, height:30);
        btn.layer.cornerRadius = 5;
        btn.widthAnchor.constraint(equalToConstant: 200).isActive = true;
        stackView.addArrangedSubview(btn);
        
        self.view.addSubview(stackView);
    }
    
    @objc func adminButton(sender: UIButton){
        let sb: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "adminTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
    }
    
    @objc func groupButton(sender: UIButton){
        let sb: UIStoryboard = UIStoryboard(name: "GroupLeader", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "groupLeaderTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
    }
    
    @objc func userButton(sender: UIButton) {
        let sb: UIStoryboard = UIStoryboard(name: "User", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "userTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
    }
    
    func loadHomeView() {
        let sb: UIStoryboard = UIStoryboard(name: "User", bundle: nil);
        let mainView = sb.instantiateViewController(identifier: "userTabBar")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainView)
        
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
