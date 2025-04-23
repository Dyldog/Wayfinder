//
//  MultiPlaceHeadingViewController.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 4/4/20.
//

import UIKit
import CoreLocation
import WayfinderKit

class MultiPlaceHeadingViewController: HeadingViewController, LocationSelectionViewControllerDelegate {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        headingView?.headingImage = UIImage(
//            named: "Arrow", in: Bundle(for: WayfinderView.self), with: nil)
//    }
    
    override func titleForEmptyDestination() -> String {
        return "North"
    }
    
    override func headingForEmptyDestination() -> CLLocationDirection {
        guard let latestHeading = self.headingView?.locationManager.latestHeading else {
            return 0
        }
        
        return latestHeading
    }
    
    // MARK: - Location Selection Manager
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationSelectionSegue" {
            let navigationController = segue.destination as! UINavigationController
            let locationSelectionVC = navigationController.viewControllers.first as! LocationSelectionViewController
            locationSelectionVC.delegate = self
        }
    }
    
    func userDidSelectLocation(_ placemark: FinderPlace?) {
        self.headingView?.destination = placemark
        
        self.updateViewsForNewDestination()
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Hall of Fame
    
    override func onHeadingViewLongPress() {
        let controller = UIAlertController(
            title: "Thank you to...",
            message: """
            Robert N - For nudging me to add favourites
            """,
            preferredStyle: .alert)
        
        controller.addAction(.init(title: "OK", style: .default))
        
        present(controller, animated: true)
    }
}


func image(with view: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
    defer { UIGraphicsEndImageContext() }
    if let context = UIGraphicsGetCurrentContext() {
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    return nil
}

private func documentDirectory() -> String {
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask,
                                                                true)
    return documentDirectory[0]
}
