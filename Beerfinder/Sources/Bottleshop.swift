//
//  Bottleshop.swift
//  Heading-Liquor
//
//  Created by Dylan Elliott on 19/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import CoreLocation

class Bottleshop: NSObject, Headable {
    let name : String
    let address : String
    let location : CLLocation
    
    init(_ dict: [String : Any]) {
        self.name = dict["name"] as! String
        self.address = dict["vicinity"] as! String
        
        let geometryDict = dict["geometry"] as! [String : Any]
        let locationDict = geometryDict["location"] as! [String : Double]
        
        self.location = CLLocation(latitude: Double(locationDict["lat"]!), longitude: Double(locationDict["lng"]!))
        
        super.init()
    }
    
    func headableName() -> String {
        return self.name
    }
    
    func headableAddress() -> String {
        return self.address
    }
    
    func headableLocation() -> CLLocation {
        return self.location
    }

}
