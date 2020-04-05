//
//  FinderLogoViewController.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import UIKit

class FinderLogoViewController: DrawViewController {

    @IBAction func doneButtonTapped() {
        do {
            try drawView
                .asImage()
                .pngData()!
                .write(to: DocumentsDirectory.url.appendingPathComponent("Drawn.png"))
            print(DocumentsDirectory.url.appendingPathComponent("Drawn.png"))
        } catch {
            print(error)
        }
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
