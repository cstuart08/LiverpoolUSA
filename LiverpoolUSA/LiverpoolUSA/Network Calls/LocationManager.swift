//
//  LocationManager.swift
//  LiverpoolUSA
//
//  Created by Cameron Stuart on 10/4/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager {
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation?
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            currentLocation = currentLoc
            print("Retreived location: \(currentLoc?.coordinate.latitude ?? 0), \(currentLoc?.coordinate.longitude ?? 0)")
        }
    }
}
