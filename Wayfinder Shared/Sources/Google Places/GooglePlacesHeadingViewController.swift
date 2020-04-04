//
//  ViewController.swift
//  Beerfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

class GooglePlacesHeadingViewController: HeadingViewController, GooglePlacesManagerDelegate {
    
    let placeManager = GooglePlacesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.placeManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func titleForEmptyDestination() -> String {
        return "Searching..."
    }
    
    override func userLocationManagerDidUpdate() {
        guard let userLocation = self.userLocationManager.latestLocation else {
            return
        }
        
        if self.destination == nil {
            self.placeManager.searchForBottleshops(near: userLocation)
        } else {
            super.userLocationManagerDidUpdate()
        }
        
        self.updateViewsForNewUserLocation()
    }
    
    func didFindPlaces(_ places: [GooglePlace]) {
        self.destination = places[0]
        
        self.updateViewsForNewDestination()
    }
}

