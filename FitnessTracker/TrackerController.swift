//
//  ViewController.swift
//  ROTC
//
//  Created by Jack Bailey on 4/5/21.
//

import UIKit
import HealthKit
import CoreLocation
import AVFoundation
import Parse


class TrackerController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var workoutAction: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    var locationManager: CLLocationManager?
    
    var seconds = 0.0
    var distance = 0.0
    var trainingHasBegun: Bool = false
    var distanceInterval = 10.0
    var milesDistance = 0.0
    var milesConversionFactor = 0.000621371
    var speed = 0.0
    var miletime = 0.0
    var metersPerMile = 1609.34
    var runDistance = 0.0 // in miles
    var currUser = String(PFUser.current()!.username!)
    var desiredPace = ""

    
    lazy var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TrackerController view loaded")
        
        loadWorkout()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest

        
        locationManager?.requestAlwaysAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("LocationManager didChangeAuthorization denied")
        case .notDetermined:
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse:
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
            
            locationManager?.requestLocation()
        case .authorizedAlways:
            print("LocationManager didChangeAuthorization authorizedAlways")
            
            locationManager?.requestLocation()
        case .restricted:
            print("LocationManager didChangeAuthorization restricted")
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager didUpdateLocations: numberOfLocations: numberOfLocation: \(locations.count)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        distance += distanceInterval
        
        locations.forEach { (location) in
            print("LocationManager didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude),\(location.coordinate.longitude)")
            print("LocationManager horizontalAccuracy: \(location.horizontalAccuracy)")
        }
        
        print("\n\nend of this didUpdateLocations\n\n")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
    }
   
    @IBAction func startTracking(_ sender: Any) {
        print("button clicked!")
        
        
        if trainingHasBegun == false {
            trainingHasBegun = true
            seconds = 0.0
            distance = 0.0
            //runDistance = 0.00 // change this value to 0.00 to test easier without having to move
            
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(self.eachSecond),
                                         userInfo: nil,
                                         repeats: true)
            
            locationManager?.distanceFilter = distanceInterval
            startLocationUpdates()
            
            trainingHasBegun = true
            
            
            
        } else {
            trainingHasBegun = false
            stopWorkout()
        }
    }

    
    @objc func eachSecond(timer: Timer) {
        seconds += 1
        
        
        timeLabel.text = String(seconds) + " s"
        
        milesDistance = distance * milesConversionFactor
        let milesString: String = String(format: "%.2f mi", milesDistance)
        
        print("runDistance: ")
        print(runDistance)
        
        if (milesDistance >= runDistance) {
            print("distance > runDistance")
            finishedWorkout()
        }
        
        distanceLabel.text = milesString
    
        miletime = ((seconds / distance) / 60) * metersPerMile
        let miletimeString: String = String(format: "%.2f min/mi", miletime)
        
        paceLabel.text = miletimeString
    }
    
    func startLocationUpdates() {
        locationManager?.startUpdatingLocation()
    }
    
    func finishedWorkout() {
        print("finishedWorkout was called")
        stopTimer()
        locationManager?.stopUpdatingLocation()
        
        let utterance = AVSpeechUtterance(string: "Congrats, you have finished your run")
        let voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.voice = voice
        
        let synthesizer = AVSpeechSynthesizer()
        
        synthesizer.speak(utterance)
        print("finished speaking")

        let db = Database()
        let runResult = PFObject(className: "RunResult")
        let resultArray = [distance, seconds, miletime]
        runResult.setObject(currUser, forKey: "netid")
        runResult.setObject(resultArray, forKey: "runresult")
        db.saveObject(obj: runResult)
        print("uploaded: ")
        print(runResult)
        
        let alert = UIAlertController(title: "Success!", message: "Run has been submitted.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func stopWorkout() {
        print("stopWorkout was called")
        stopTimer()
        locationManager?.stopUpdatingLocation()
    }
    
    func stopTimer() {
        timer.invalidate()
        print("Timer stopped")
    }
    
    func loadWorkout() {
        let db = Database()
        db.saveInstallationObject()
        //db.queryFirstObject(predicateStr:"netid='jbailey7'",className:"Workouts",callback:workoutCallback(obj:error:))
        db.queryFirstObject(predicateStr:"netid='\(currUser)'",className:"Runs",callback:workoutCallback(obj:error:))

    }
    
    func workoutCallback(obj: PFObject?, error:Error?) -> Void {
        if(error == nil){
            print(obj)
            let w = (obj?["RunData"])! as! Array<Any>
        
            
            runDistance = w[0] as! Double
            desiredPace = w[1] as! String
            let xVal = 200
            var yVal = 200
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 80))
            label.center = CGPoint(x: xVal, y: yVal)
            label.textAlignment = .center
            
            label.text = "distance: " + String(runDistance) + " mi"
            label.font = label.font.withSize(30)
            label.textColor = UIColor.black
            label.layer.borderColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
            label.layer.borderWidth = 3.0

            label.layer.masksToBounds = true

            self.view.addSubview(label)
            
            yVal += 100
            
            let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 80))
            label2.center = CGPoint(x: xVal, y: yVal)
            label2.textAlignment = .center
            
            label2.text = "pace: " + desiredPace + " min/mi"
            label2.font = label.font.withSize(30)
            label2.textColor = UIColor.black
            label2.layer.borderColor = UIColor(red: 45/255, green: 77/255, blue: 123/255, alpha: 1.0).cgColor
            label2.layer.borderWidth = 3.0
            label2.layer.masksToBounds = true

            self.view.addSubview(label2)

        } else {
            print(error?.localizedDescription)
        }
        
    }
}

