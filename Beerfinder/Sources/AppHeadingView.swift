//
//  HeadingBottleView.swift
//  Heading-Liquor
//
//  Created by Dylan Elliott on 21/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
import CoreGraphics
@IBDesignable
class AppHeadingView: HeadingView {
    
    let headingImage = UIImage(named: "BeerBottle")!
    let imageScale : CGFloat = 0.5
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: rect.midX, y: rect.midY)
        context?.rotate(by: -headingAngle)
        context?.translateBy(x: -rect.midX, y: -rect.midY)
        //context?.translateBy(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
        
        //let insetRect = rect.insetBy(dx: (1.0 - imageScale) * rect.width, dy: (1.0 - imageScale) * rect.height)
        
        context?.scaleBy(x: imageScale, y:imageScale)
        
        headingImage.draw(at: CGPoint(x: (rect.midX / imageScale - headingImage.size.width / 2.0),
                                      y: (rect.midY / imageScale - headingImage.size.height / 2.0)))
    }
    

}
