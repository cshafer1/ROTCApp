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

    
    lazy var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TrackerController view loaded")
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest

        
        locationManager?.requestAlwaysAuthorization()
        
        //workoutAction.backgroundColor = UIColor(red: 45, green: 77, blue: 123, alpha: 1)
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
            runDistance = 0.05 // pull this value from database
            
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
}

