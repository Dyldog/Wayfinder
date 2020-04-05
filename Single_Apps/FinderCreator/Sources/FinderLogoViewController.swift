//
//  FinderLogoViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit

class FinderLogoViewController: DrawViewController {

    var selectedType: GooglePlace.PlaceType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Draw Logo"
    }
    
    @IBAction func doneButtonTapped() {
        do {
            let headingImage = try drawView.asImage().trim()
//                .pngData()!
//                .write(to: DocumentsDirectory.url.appendingPathComponent("Drawn.png"))
//            print(DocumentsDirectory.url.appendingPathComponent("Drawn.png"))
            showHeadingScreen(headingImage: headingImage)
        } catch {
            print(error)
        }
    }
    
    func showHeadingScreen(headingImage: UIImage) {
        let headingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! FinderColorsViewController
        headingViewController.headingImage = headingImage
        headingViewController.selectedPlaceType = selectedType
        navigationController?.pushViewController(headingViewController, animated: true)
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

enum DocumentsDirectory {
    static var url: URL {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentDirectoryPath)
    }
}
