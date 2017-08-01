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

protocol LocationSearchManagerDelegate {
    func locationSearchManagerDidFindPlaces(places: [MKPlacemark], searchText: String)
}

class LocationSearchManager: NSObject {
    let geocoder = CLGeocoder()
    var lastSearch : MKLocalSearch?
    
    var delegate : LocationSearchManagerDelegate?
    
    func searchForLocationsWithString(searchText: String) {
        if lastSearch != nil {
            lastSearch?.cancel()
        }
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        lastSearch = search
        
        search.start { (response, error) in
            var placemarks = [MKPlacemark]()
            if let response = response {
                for mapItem in response.mapItems {
                    placemarks.append(mapItem.placemark)
                }
            }
            
            self.delegate?.locationSearchManagerDidFindPlaces(places: placemarks, searchText: searchText)
            
            self.lastSearch = nil
        }
    }

}
