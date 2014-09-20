//
//  ViewController.swift
//  MetallDetektor
//
//  Created by Marcel Hess on 20.09.14.
//  Copyright (c) 2014 Marcel Hess. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var qwertSlide: UIProgressView!
    @IBOutlet var qwert: UILabel!
    
    let locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }

    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading:
        CLHeading!) {
        let magnitude:Double = sqrt(pow(newHeading.x, 2) + pow(newHeading.y, 2) + pow(newHeading.z, 2));
            
        //qwert.text = toString(magnitude)
        qwert.text = NSString(format: "%.2F", magnitude)
        
        let maxMagnitude = 1500
        let magnitudeRatio:Float = Float(magnitude) / Float(maxMagnitude)
        qwertSlide.progress =  magnitudeRatio
            
        // show color
        
    }


}

