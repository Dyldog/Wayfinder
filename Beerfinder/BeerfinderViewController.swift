//
//  ViewController.swift
//  Beerfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

class BeerfinderViewController: HeadingViewController, BottleshopManagerDelegate {
    
    let bottleshopManager = BottleshopManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.bottleshopManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func userLocationManagerDidUpdate() {
        guard let userLocation = self.userLocationManager.latestLocation else {
            return
        }
        
        if self.destination == nil {
            self.bottleshopManager.searchForBottleshops(near: userLocation)
        } else {
            super.userLocationManagerDidUpdate()
        }
        
        self.updateViewsForNewUserLocation()
    }
    
    func didFindBottleshops(_ bottleshops: [Bottleshop]) {
        self.destination = bottleshops[0]
        
        self.updateViewsForNewDestination()
    }
}

