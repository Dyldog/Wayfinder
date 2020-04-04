//
//  ViewController.swift
//  Heading
//
//  Created by Dylan Elliott on 2/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

// View Colors
// Arrow: #E74C3D
// Background: #2C3E50
// Destination View: #34495E

import UIKit
import CoreLocation

class HeadingViewController: UIViewController, UserLocationManagerDelegate {
    
    var userLocationManager: UserLocationManagerType
    var destination : Headable?
    
    @IBOutlet var headingView : HeadingView?
    
    @IBOutlet var bottomView: UIView?
    @IBOutlet var distanceView: UIView?
    @IBOutlet var distanceTitleLabel : UILabel?
    @IBOutlet var distanceLabel : UILabel?
    
    @IBOutlet var destinationView: UIView?
    @IBOutlet var destinationTitleLabel : UILabel?
    @IBOutlet var destinationLabel : UILabel?
    
    @IBOutlet var changeLocationButton: UIButton?
    
    required init?(coder: NSCoder) {
        if LaunchArguments.mockLocation.isPresent {
            userLocationManager = MockUserLocationManager()
        } else {
            userLocationManager = UserLocationManager()
        }
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .background
        destinationView?.backgroundColor = .toolbar
        bottomView?.backgroundColor = .toolbar
        
        destinationTitleLabel?.textColor = .h1
        destinationLabel?.textColor = .h2
        
        distanceTitleLabel?.textColor = .h1
        distanceLabel?.textColor = .h2
        
        changeLocationButton?.setTitleColor(.button, for: .normal)
        
        userLocationManager.delegate = self
        userLocationManager.startLocationEvents()
        
        self.updateViewsForNewDestination()
        
        // For taking screenshots
//        self.destinationLabel!.text = "ADVENTURE!!"
//        self.distanceLabel!.text = "1337 km"
//        self.headingView!.headingAngle = -0.5
    }
    
    // MARK: - User Location Manager
    
    func userLocationManagerDidUpdate() {
        self.updateViewsForNewUserLocation()
    }
    
    // MARK: - View Updating
    
    func updateArrowViewPosition() {
        let topMargin : CGFloat = self.destinationView!.frame.maxY
        let bottomMargin : CGFloat = self.bottomView!.frame.minY
        
        self.headingView!.frame.origin.x = self.view.frame.width / 2 - self.headingView!.frame.width / 2
        self.headingView!.frame.origin.y = topMargin + (bottomMargin - topMargin) / 2 - self.headingView!.frame.height / 2
        
    }
    
    func updateHeadingViewAngle() {
        guard let latestHeading = self.userLocationManager.latestHeading else {
            print("No heading yet...")
            return
        }
        
        if let destinationLocation = self.destination?.headableLocation() { // We're pointing towards north
            guard let userLocation = self.userLocationManager.latestLocation else {
                print("No location yet...")
                return
            }
            
            let destinationAngle = userLocation.bearingBetween(heading: latestHeading, and: destinationLocation).toRadians()
            
            headingView?.headingAngle = CGFloat(destinationAngle)
        } else { // We're pointing towards the destination
            let northAngle = self.headingForEmptyDestination()
            let northAngleRadians = northAngle.toRadians()
            headingView?.headingAngle = CGFloat(northAngleRadians)
        }
        
        headingView?.setNeedsDisplay()
    }
    
    func updateDistanceLabel() {
        if let userLocation = self.userLocationManager.latestLocation, let destination = self.destination {
            let metersToLocation = userLocation.distance(from: destination.headableLocation())
            
            var distanceString = ""
            
            switch Int(metersToLocation) {
            case 0...1000:
                distanceString = String(format:"%d m", Int(metersToLocation))
                break
            //case  101...1000:
            //    return String(format:"%.2f km", metersToLocation / 1000.0)
            default:
                distanceString = String(format:"%.1f km", metersToLocation / 1000.0)
                break
            }
            
            
            self.distanceLabel?.text = distanceString
        }
    }
    
    func titleForEmptyDestination() -> String {
        return "No Destination"
    }
    
    func headingForEmptyDestination() -> CLLocationDirection {
        return 0 as CLLocationDirection
    }
    
    func updateDestinationLabel() {
        if let destination = self.destination {
            self.destinationLabel?.text = destination.headableName()
        } else {
            self.destinationLabel?.text = self.titleForEmptyDestination()
        }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func updateViewsForNewDestination() {
        if self.destination != nil {
            self.distanceView?.isHidden = false
        } else {
            self.distanceView?.isHidden = true
        }
        
        updateDestinationLabel()
        updateArrowViewPosition()
        
        updateViewsForNewUserLocation()
    }
    
    func updateViewsForNewUserLocation() {
        updateHeadingViewAngle()
        updateDistanceLabel()
    }

}

