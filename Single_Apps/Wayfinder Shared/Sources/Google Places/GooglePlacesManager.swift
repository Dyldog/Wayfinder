//
//  GooglePlacesManager.swift
//  Heading-Liquor
//
//  Created by Dylan Elliott on 19/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

protocol GooglePlacesManagerDelegate {
    func didFindPlaces(_ places: [GooglePlace])
}

class GooglePlacesManager: NSObject {
    
    var currentRequest : DataRequest?
    var delegate : GooglePlacesManagerDelegate?
    
    var placesType: String
    
    let googlePlacesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
//    let googleMapsAPIKey : String = {
//        let path = Bundle.main.path(forResource: "Credentials", ofType: "plist")!
//        let keys = NSDictionary(contentsOfFile: path)!
//        return keys.object(forKey: "googleMapsAPIKey") as! String
//    }()
    
    override init() {
        placesType = Bundle.main.infoDictionary!["WFPlacesType"] as! String
    }
    
    func searchForBottleshops(near searchLocation: CLLocation){
        guard currentRequest == nil else {
            return
        }
        
        let locationString = "\(searchLocation.coordinate.latitude),\(searchLocation.coordinate.longitude)"
        let requestParams = ["location" : locationString,
                             "rankby" : "distance",
                             "type" : placesType,
                             "key" : googleAPIKey,
                             "opennow" : "true"]
        
        currentRequest = AF.request(googlePlacesURL, parameters: requestParams)
        currentRequest!.responseJSON { response in
            switch response.result {
            case .success(let responseJSON as [String: Any]):
                var bottleshops = [GooglePlace]()
                
                for bottleshopDict in responseJSON["results"] as! [[String : Any]] {
                    let newBottleshop = GooglePlace(bottleshopDict)
                    
                    bottleshops.append(newBottleshop)
                }
                self.delegate?.didFindPlaces(bottleshops)
                
                self.currentRequest = nil
            case .success:
                break
            case .failure(let error):
                break
            }
        }
    }

}
