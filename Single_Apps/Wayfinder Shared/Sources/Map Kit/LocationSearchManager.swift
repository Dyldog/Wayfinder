//
//  AddressManager.swift
//  Heading
//
//  Created by Dylan Elliott on 4/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import WayfinderKit

protocol LocationSearchManagerDelegate {
    func locationSearchManagerDidFindPlaces(places: [FinderPlace], searchText: String)
}

class LocationSearchManager: NSObject {
    let geocoder = CLGeocoder()
    var lastSearch : MKLocalSearch?
    
    var delegate : LocationSearchManagerDelegate?
    
    func searchForLocationsWithString(searchText: String) {
        if lastSearch != nil {
            lastSearch?.cancel()
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        lastSearch = search
        
        search.start { (response, error) in
            self.lastSearch = nil
            
            guard let response = response else { return }
            
            let places = response.mapItems.map { $0.placemark.finderPlace }
            
            self.delegate?.locationSearchManagerDidFindPlaces(
                places: places, searchText: searchText)
        }
    }
}

private extension MKPlacemark {
    var finderPlace: FinderPlace {
        .init(
            name: headableName(),
            address: headableAddress(),
            location: headableLocation()
        )
    }
}
