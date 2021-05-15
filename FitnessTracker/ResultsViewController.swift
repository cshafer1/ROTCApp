//
//  LogInViewController.swift
//  FitnessTracker
//
//  Created by Chris on 4/6/21.
//

import UIKit
import Parse

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsField: UITextView!;
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsField.isEditable = false;
        resultsField.isSelectable = false;
        var query = PFQuery(className: "RunResult")
        query.findObjectsInBackground() { (results: [PFObject]!, err:Error!) in
            for obj in results! {
                var netid = obj["netid"] as! String
                var strings = ((obj["runresult"] as AnyObject).description?.replacingOccurrences(of: "\n", with: ""))!
                var str = "Run: " + netid + "-" + strings + "\n"
                self.resultsField.text = self.resultsField.text + str;
            }
        }
        query = PFQuery(className: "LiftResult")
        query.findObjectsInBackground() { (results: [PFObject]!, err:Error!) in
            for obj in results! {
                var netid = obj["netid"] as! String
                var strings = ((obj["liftresult"] as AnyObject).description?.replacingOccurrences(of: "\n", with: ""))!
                var str = "Lift: " + netid + "-" + strings + "\n"
                self.resultsField.text = self.resultsField.text + str;
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
