//
//  LocationSelectionViewController.swift
//  Heading
//
//  Created by Dylan Elliott on 4/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import Contacts
import DylKit
import MapKit
import UIKit

protocol LocationSelectionViewControllerDelegate {
    func userDidSelectLocation(_ placemark: FinderPlace?)
}

class LocationSelectionViewController: UIViewController, UITextFieldDelegate, LocationSearchManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let locationSearchManager = LocationSearchManager()
    
    var places = [FinderPlace]()
    @UserDefaultable(key: "SAVED_PLACES") var savedPlaces: [FinderPlace] = []
    
    @IBOutlet var placesTableView : UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var keyboardSpaceConstraint : NSLayoutConstraint?
    @IBOutlet weak var buttonView: UIView?
    
    private var searchText: String? {
        let text = searchTextField.text ?? ""
        return text.isEmpty ? nil : text
    }
    
    private var isSearching: Bool { searchText != nil }
    
    private var displayedPlaces: [FinderPlace] {
        isSearching ? places : savedPlaces
    }
    
    var delegate : LocationSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.placeholder = "Search"
        
        navigationController?.navigationBar.backgroundColor = .toolbar
        view.backgroundColor = .toolbar
        placesTableView.backgroundColor = .background
        placesTableView.rowHeight = UITableView.automaticDimension
        buttonView?.backgroundColor = .toolbar
        
        self.locationSearchManager.delegate = self
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //TODO: Change to UIKeyboardWillChangeFrame notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIControl Methods
    
    @objc func keyboardWillShow(notification: Notification) {
        
            
        let infoDict = notification.userInfo!
        let keyboardFrame = (infoDict[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = keyboardFrame.height
        
        keyboardSpaceConstraint?.constant = keyboardHeight - self.buttonView!.frame.height
    }
    
    @objc func keyboardWillHide(notification: Notification) {
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
    
    private func hasStarredPlace(_ place: FinderPlace) -> Bool {
        savedPlaces.contains(where: { $0.id == place.id })
    }
    
    func locationSearchManagerDidFindPlaces(places: [FinderPlace], searchText: String) {
        self.places = places
        self.placesTableView!.reloadData()
    }
    
    // MARK: - Tableview Delegate/Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        isSearching ? "Search Results" : "Saved Places"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationTableViewCell = tableView.dequeue(for: indexPath)
        
        let currentPlace = displayedPlaces[indexPath.row]
        
        cell.bind(with: .init(
            name: currentPlace.name,
            address: currentPlace.address,
            isStarred: hasStarredPlace(currentPlace)
        ))
        
        cell.onStarTapped = { [weak self] in
            guard let self else { return }
            
            if hasStarredPlace(currentPlace) {
                savedPlaces.removeAll(where: { $0.id == currentPlace.id })
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                savedPlaces.append(currentPlace)
                tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .automatic)
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = displayedPlaces[indexPath.row]
        
        self.delegate?.userDidSelectLocation(selectedPlace)
    }
    
    @IBAction func clearLocationButtonTapped() {
        self.delegate?.userDidSelectLocation(nil)
    }
}
