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


class WorkoutController: UIViewController, UIApplicationDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WorkoutController view loaded")
        // Do any additional setup after loading the view.
        
        loadWorkout()
        
        
    }
    
    func loadWorkout() {
        let db = Database()
        db.saveInstallationObject()
        db.queryFirstObject(predicateStr:"netid='jbailey7'",className:"Workouts",callback:workoutCallback(obj:error:))
    }
    
    
    /*
     let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
     label.center = CGPoint(x: 160, y: 285)
     label.textAlignment = .center
     label.text = "I'm a test label"
     self.view.addSubview(label)
     */
    func workoutCallback(obj: PFObject?, error:Error?) -> Void {
        if(error == nil){
            print(obj)
            let w = (obj?["workout"])! as! Array<Any>
            print(w)
            
            
            var xVal = 200
            var yVal = 200
            
            for exercise in w {
                print(exercise)
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 113))
                label.center = CGPoint(x: xVal, y: yVal)
                label.textAlignment = .center
                label.text = exercise as? String
                label.layer.backgroundColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
                label.font = label.font.withSize(65)
                label.adjustsFontSizeToFitWidth = true
                label.layer.cornerRadius = 35
                label.layer.masksToBounds = true

                self.view.addSubview(label)
                
                //xVal += 50
                yVal += 150
            }
            print("\n\n\n")

            //func object(forKey key: String) -> Any?

        } else {
            print(error?.localizedDescription)
        }
    }
}

