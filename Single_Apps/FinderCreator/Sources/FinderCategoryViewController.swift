//
//  FinderCategoryViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit

class FinderCategoryViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Category"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GooglePlace.PlaceType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .default, reuseIdentifier: cellID)
        cell.backgroundColor = .background
        cell.textLabel?.textColor = .h2
        let placeType = GooglePlace.PlaceType.allCases[indexPath.row]
        cell.textLabel?.text = placeType.rawValue
            .components(separatedBy: "_").map { $0.capitalized }.joined(separator: " ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeType = GooglePlace.PlaceType.allCases[indexPath.row]
        let logoViewController = UIStoryboard(name: "DrawView", bundle: nil).instantiateInitialViewController() as! FinderLogoViewController
        logoViewController.selectedType = placeType
        navigationController?.pushViewController(logoViewController, animated: true)
    }
}

extension GooglePlace {
    enum PlaceType: String, CaseIterable, Codable {
        case accounting
        case airport
        case amusement_park
        case aquarium
        case art_gallery
        case atm
        case bakery
        case bank
        case bar
        case beauty_salon
        case bicycle_store
        case book_store
        case bowling_alley
        case bus_station
        case cafe
        case campground
        case car_dealer
        case car_rental
        case car_repair
        case car_wash
        case casino
        case cemetery
        case church
        case city_hall
        case clothing_store
        case convenience_store
        case courthouse
        case dentist
        case department_store
        case doctor
        case drugstore
        case electrician
        case electronics_store
        case embassy
        case fire_station
        case florist
        case funeral_home
        case furniture_store
        case gas_station
        case grocery_or_supermarket
        case gym
        case hair_care
        case hardware_store
        case hindu_temple
        case home_goods_store
        case hospital
        case insurance_agency
        case jewelry_store
        case laundry
        case lawyer
        case library
        case light_rail_station
        case liquor_store
        case local_government_office
        case locksmith
        case lodging
        case meal_delivery
        case meal_takeaway
        case mosque
        case movie_rental
        case movie_theater
        case moving_company
        case museum
        case night_club
        case painter
        case park
        case parking
        case pet_store
        case pharmacy
        case physiotherapist
        case plumber
        case police
        case post_office
        case primary_school
        case real_estate_agency
        case restaurant
        case roofing_contractor
        case rv_park
        case school
        case secondary_school
        case shoe_store
        case shopping_mall
        case spa
        case stadium
        case storage
        case store
        case subway_station
        case supermarket
        case synagogue
        case taxi_stand
        case tourist_attraction
        case train_station
        case transit_station
        case travel_agency
        case university
        case veterinary_care
        case zoo
    }
}
