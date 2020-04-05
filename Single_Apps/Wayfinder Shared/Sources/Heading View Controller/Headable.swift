//
//  Headable.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import CoreLocation

protocol Headable {
    func headableName() -> String
    func headableLocation() -> CLLocation
    func headableAddress() -> String
}

extension CLPlacemark : Headable {
    func headableName() -> String {
        return self.name!
    }
    
    func headableLocation() -> CLLocation {
        return self.location!
    }
    
    func headableAddress() -> String {
        var addressLines : [String] = self.addressDictionary!["FormattedAddressLines"] as! [String]
        
        if self.headableName() == addressLines[0] {
            addressLines = Array(addressLines[1..<addressLines.count])
        }
        
        let placeAddress = addressLines.joined(separator: ", ")
        return placeAddress
    }
}
