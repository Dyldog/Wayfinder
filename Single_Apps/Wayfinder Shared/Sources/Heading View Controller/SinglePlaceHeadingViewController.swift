//
//  ViewController.swift
//  Beerfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

class SinglePlaceHeadingViewController: HeadingViewController, GooglePlacesManagerDelegate {
    
    let placeManager = GooglePlacesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.placeManager.delegate = self
        self.changeLocationButton?.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func titleForEmptyDestination() -> String {
        return "Searching..."
    }
    
    override func wayfinderViewDidUpdate() {
        guard let userLocation = self.headingView?.locationManager.latestLocation else {
            return
        }
        
        if self.headingView?.destination == nil {
            self.placeManager.searchForBottleshops(near: userLocation)
        } else {
            super.wayfinderViewDidUpdate()
        }
        
        self.updateViewsForNewUserLocation()
    }
    
    func didFindPlaces(_ places: [GooglePlace]) {
        self.headingView?.destination = places.first
        
        self.updateViewsForNewDestination()
    }
}

