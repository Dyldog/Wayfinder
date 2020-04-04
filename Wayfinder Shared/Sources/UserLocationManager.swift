//
//  HeadingManager.swift
//  Heading
//
//  Created by Dylan Elliott on 2/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

// Bearing is angle between locations
// Heading is compass direction/angle to north

import UIKit
import CoreLocation

protocol UserLocationManagerDelegate {
    // TODO: Make separate methods for location and heading updates
    func userLocationManagerDidUpdate()
}

extension Double {
    func toRadians() -> Double {
        return self * Double.pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / Double.pi
    }
}

extension CLLocation {
    func bearingTo(destination: CLLocation) -> CLLocationDirection {
        var bearing: CLLocationDirection
        
        let fromLat = self.coordinate.latitude.toRadians()
        let fromLon = self.coordinate.longitude.toRadians()
        let toLat = destination.coordinate.latitude.toRadians()
        let toLon = destination.coordinate.longitude.toRadians()
        
        let y = sin(toLon - fromLon) * cos(toLat)
        let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLon - fromLon)
        bearing = atan2(y,x).toDegrees() as CLLocationDirection
        
        bearing = (bearing + 360.0).truncatingRemainder(dividingBy: 360.0)
        
        return bearing
    }
    
    func bearingBetween(heading: CLLocationDirection, and destination: CLLocation) -> CLLocationDirection  {
        var bearing: CLLocationDirection
        
        let userAngleFromNorth = heading
        let destinationAngleFromNorth = self.bearingTo(destination: destination)
        let destinationAngleFromUser = userAngleFromNorth - destinationAngleFromNorth
        
        bearing = destinationAngleFromUser
        
        return bearing
    }
}

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    var delegate : UserLocationManagerDelegate?
    
    var latestHeading : CLLocationDirection?
    var latestLocation : CLLocation?
    
    func startLocationEvents() {
        locationManager.delegate = self
        
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        // Debug
        //print(newHeading.trueHeading)
        
        self.latestHeading = newHeading.trueHeading
        self.delegate?.userLocationManagerDidUpdate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // Debug
        //print(locations)
        
        if let newLocation = locations.last {
            self.latestLocation = newLocation
            self.delegate?.userLocationManagerDidUpdate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
