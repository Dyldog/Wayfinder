//
//  BottleshopManager.swift
//  Heading-Liquor
//
//  Created by Dylan Elliott on 19/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

protocol BottleshopManagerDelegate {
    func didFindBottleshops(_ bottleshops: [Bottleshop])
}

class BottleshopManager: NSObject {
    
    var currentRequest : DataRequest?
    var delegate : BottleshopManagerDelegate?
    
    let googlePlacesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
//    let googleMapsAPIKey : String = {
//        let path = Bundle.main.path(forResource: "Credentials", ofType: "plist")!
//        let keys = NSDictionary(contentsOfFile: path)!
//        return keys.object(forKey: "googleMapsAPIKey") as! String
//    }()
    
    func searchForBottleshops(near searchLocation: CLLocation){
        guard currentRequest == nil else {
            return
        }
        
        let locationString = "\(searchLocation.coordinate.latitude),\(searchLocation.coordinate.longitude)"
        let requestParams = ["location" : locationString,
                             "rankby" : "distance",
                             "type" : "liquor_store",
                             "key" : googleAPIKey]
        
        currentRequest = Alamofire.request(googlePlacesURL, parameters: requestParams)
        currentRequest!.responseJSON { response in
            if let responseJSON = response.result.value as? [String : Any] {
                var bottleshops = [Bottleshop]()
                
                for bottleshopDict in responseJSON["results"] as! [[String : Any]] {
                    let newBottleshop = Bottleshop(bottleshopDict)
                    
                    bottleshops.append(newBottleshop)
                }
                self.delegate?.didFindBottleshops(bottleshops)
                
                self.currentRequest = nil
            }
        }
    }

}
