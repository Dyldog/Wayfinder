//
//  ViewController.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: HeadingViewController, LocationSelectionViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func titleForEmptyDestination() -> String {
        return "North"
    }
    
    override func headingForEmptyDestination() -> CLLocationDirection {
        guard let latestHeading = self.userLocationManager.latestHeading else {
            return 0
        }
        
        return latestHeading
    }
    
    // MARK: - Location Selection Manager
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationSelectionSegue" {
            let locationSelectionVC = segue.destination as! LocationSelectionViewController
            locationSelectionVC.delegate = self
        }
    }
    
    func userDidSelectLocation(_ placemark: CLPlacemark?) {
        self.destination = placemark
        
        self.updateViewsForNewDestination()
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }

}

