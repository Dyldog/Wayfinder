//
//  LocationSelectionViewController.swift
//  Heading
//
//  Created by Dylan Elliott on 4/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol LocationSelectionViewControllerDelegate {
    func userDidSelectLocation(_ placemark: CLPlacemark?)
}

class LocationSelectionViewController: UIViewController, UITextFieldDelegate, LocationSearchManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let locationSearchManager = LocationSearchManager()
    
    var places = [MKPlacemark]()
    
    @IBOutlet var placesTableView : UITableView?
    @IBOutlet var keyboardSpaceConstraint : NSLayoutConstraint?
    @IBOutlet weak var buttonView: UIView?
    
    var delegate : LocationSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationSearchManager.delegate = self
        
        self.placesTableView!.delegate = self
        self.placesTableView!.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //TODO: Change to UIKeyboardWillChangeFrame notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIControl Methods
    
    func keyboardWillShow(notification: Notification) {
        
            
        let infoDict = notification.userInfo!
        let keyboardFrame = (infoDict[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = keyboardFrame.height
        
        keyboardSpaceConstraint?.constant = keyboardHeight - self.buttonView!.frame.height
    }
    
    func keyboardWillHide(notification: Notification) {
        keyboardSpaceConstraint?.constant = 0
    }
    
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let searchString = textField.text {
            locationSearchManager.searchForLocationsWithString(searchText: searchString)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    
    
    // MARK: - Address Manager Methods
    
    func locationSearchManagerDidFindPlaces(places: [MKPlacemark], searchText: String) {
        self.places = places
        self.placesTableView!.reloadData()
    }
    
    // MARK: - Tableview Delegate/Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "LocationCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        let currentPlace = places[indexPath.row]
        
        cell!.textLabel?.text = currentPlace.headableName()
        cell!.detailTextLabel?.text = currentPlace.headableAddress()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = places[indexPath.row]
        
        self.delegate?.userDidSelectLocation(selectedPlace)
    }
    
    @IBAction func clearLocationButtonTapped() {
        self.delegate?.userDidSelectLocation(nil)
    }

}
