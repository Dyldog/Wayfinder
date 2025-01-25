//
//  FinderPlace.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 29/12/2024.
//

import Foundation
import CoreLocation

struct FinderPlace: Codable {
    var id: String { name + address }
    
    let name: String
    let address: String
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0

    var location: CLLocation {
        get {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.coordinate.latitude
            longitude = newValue.coordinate.longitude
        }
    }
    
    init(name: String, address: String, location: CLLocation) {
        self.name = name
        self.address = address
        self.location = location
    }
}

extension FinderPlace: Headable {
    func headableName() -> String { name }
    func headableLocation() -> CLLocation { location }
    func headableAddress() -> String { address }
}
