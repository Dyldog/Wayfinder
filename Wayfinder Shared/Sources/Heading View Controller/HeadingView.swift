//
//  HeadingView.swift
//  Heading
//
//  Created by Dylan Elliott on 2/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

@IBDesignable

class HeadingView: UIView {
    
    var headingAngle:  CGFloat = 0.0
    
    @IBInspectable var headingImage: UIImage?
    @IBInspectable var imageScale : CGFloat = 1.0
    
    var imageToViewScale: CGFloat! {
        let imageSize = headingImage!.size
        let longestLength = max(imageSize.width, imageSize.height)
        
        return frame.width / longestLength * imageScale
    }
    
    init(image: UIImage, scale: CGFloat) {
        self.headingImage = image
        self.imageScale = scale
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        headingImage = UIImage(named: "Arrow")
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let headingImage = headingImage else { return }
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: rect.midX, y: rect.midY)
        context?.rotate(by: -headingAngle)
        context?.translateBy(x: -rect.midX, y: -rect.midY)
        //context?.translateBy(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
        
        //let insetRect = rect.insetBy(dx: (1.0 - imageScale) * rect.width, dy: (1.0 - imageScale) * rect.height)
        
        context?.scaleBy(x: imageToViewScale, y:imageToViewScale)
        
        headingImage.draw(at: CGPoint(x: (rect.midX / imageToViewScale - headingImage.size.width / 2.0),
                                      y: (rect.midY / imageToViewScale - headingImage.size.height / 2.0)))
    }
    
 

}
