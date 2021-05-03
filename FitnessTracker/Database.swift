//
//  Database.swift
//  FitnessTracker
//
//  Created by Chris on 3/23/21.
//

import Foundation
import Parse



class Database {
    func saveInstallationObject() {
        if let installation = PFInstallation.current() {
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("Loaded Back4App and wrote to database");
                }
                else {
                    if let myError = error {
                        print(myError.localizedDescription)
                    } else {
                        print("Unknown error");
                    }
                }
            }
        }
    }
    
    func saveObject(obj: PFObject){
        obj.saveInBackground {
            (success, error) in
            if(success){
            } else {
                print(error?.localizedDescription ?? "Unknown Error");
            }
        }
    }
    
    func queryObjects(predicateStr: String, className: String, callback: @escaping ([AnyObject]?, Error?) -> Void) {
        let predicate = NSPredicate(format:predicateStr);
        let query = PFQuery(className: className, predicate: predicate)
        query.findObjectsInBackground(block: callback);
    }
    
    func queryFirstObject(predicateStr: String, className: String, callback: @escaping (PFObject?, Error?) -> Void) {
        let predicate = NSPredicate(format:predicateStr);
        let query = PFQuery(className: className, predicate: predicate)
        query.getFirstObjectInBackground(block: callback);
    }
    
    
}
