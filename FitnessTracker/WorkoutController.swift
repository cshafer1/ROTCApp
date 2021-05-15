//
//  WorkoutController.swift
//  ROTC
//
//  Created by Jack Bailey on 5/2/21.
//

import UIKit
import AVFoundation
import CoreData
import Parse


class WorkoutController: UIViewController, UIApplicationDelegate, UITextFieldDelegate {
    
    var labels = [UITextField]()
    var currUser = String(PFUser.current()!.username!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("WorkoutController view loaded")
        // Do any additional setup after loading the view.
        
        initializeHideKeyboard()
        loadWorkout()
        
        
    }
    
    func loadWorkout() {
        let db = Database()
        db.saveInstallationObject()
        //db.queryFirstObject(predicateStr:"netid='jbailey7'",className:"Workouts",callback:workoutCallback(obj:error:))
        db.queryFirstObject(predicateStr:"netid='\(currUser)'",className:"Workouts",callback:workoutCallback(obj:error:))

    }
    
    func workoutCallback(obj: PFObject?, error:Error?) -> Void {
        if(error == nil){
            print(obj)
            let w = (obj?["workout"])! as! Array<Any>
            print(w)
            
            
            let xVal = 200
            var yVal = 200
            
            for exercise in w {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 80))
                label.center = CGPoint(x: xVal, y: yVal)
                label.textAlignment = .center
                
                label.text = exercise as? String
                //label.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
                label.font = label.font.withSize(30)
                label.textColor = UIColor.black
                label.layer.borderColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
                label.layer.borderWidth = 3.0
                //label.adjustsFontSizeToFitWidth = true
                //label.layer.cornerRadius = 35
                label.layer.masksToBounds = true

                self.view.addSubview(label)
                
                //xVal += 50
                yVal += 100
            }
            
            yVal -= 35
            
            let header = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 28))
            header.center = CGPoint(x: xVal, y: yVal)
            header.text = "(performed)"
            header.font = header.font.withSize(22)
            header.textColor = UIColor.black
            self.view.addSubview(header)
            
            yVal += 44

            for exercise in w {
                let input = UITextField(frame: CGRect(x: 0, y: 0, width: 374, height: 50))
                input.placeholder = exercise as? String
                input.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
                input.center = CGPoint(x: xVal, y: yVal)
                input.font = input.font?.withSize(30)
                
                            
                self.view.addSubview(input)
                
                yVal += 80
                
                labels.append(input)
            }
            
            let submit = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
            submit.setTitle("submit", for: .normal)
            
            
            //btn.titleLabel?.font = .systemFont(ofSize: 12)
            submit.titleLabel?.font = .systemFont(ofSize: 30)
            submit.layer.cornerRadius = 20

            //myButton.titleLabel?.font =  UIFont(name: YourfontName, size: 20)

            submit.center = CGPoint(x: xVal, y: yVal)
            submit.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
            submit.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
            
            self.view.addSubview(submit)
            
            print("\n\n\n")


        } else {
            print(error?.localizedDescription)
        }
        
    }
    
    @objc func submitAction() {
        var results = [String]()
        
        for label in labels {
            results.append(String?(label.text ?? "n/a") ?? "n/a")
        }
        
        /*
         PFUser.currentUser()!.fetchInBackgroundWithBlock({ (currentUser: PFObject?, error: NSError?) -> Void in

         // Update your data

                             if let user = currentUser as? PFUser {

                                 var email = user.email

                             }
                         })
         */
        print("user?: ")
        print(PFUser.current()!.username!)
        
        let db = Database()
        let liftResult = PFObject(className: "LiftResult")
        liftResult.setObject(currUser, forKey: "netid")
        liftResult.setObject(results, forKey: "liftresult")
        db.saveObject(obj: liftResult)
        
        print("wrote liferesult: ")
        print(results)
        /*
        class ViewController: UIViewController {

            @IBAction func showAlertButtonTapped(_ sender: UIButton) {

                // create the alert
                let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        */
        let alert = UIAlertController(title: "Success!", message: "Workout has been submitted.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

