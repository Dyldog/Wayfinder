//
//  FinderPlace.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 29/12/2024.
//

import Foundation
import CoreLocation

public struct FinderPlace: Codable {
    public var id: String { name + address }
    
    public let name: String
    public let address: String
    
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
    
    public init(name: String, address: String, location: CLLocation) {
        self.name = name
        self.address = address
        self.location = location
    }
}

extension FinderPlace: Headable {
    public func headableName() -> String { name }
    public func headableLocation() -> CLLocation { location }
    public func headableAddress() -> String { address }
}
