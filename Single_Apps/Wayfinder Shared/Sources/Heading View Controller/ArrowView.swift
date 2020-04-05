//
//  HeadingArrowView.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

class ArrowView: HeadingView {
    
    @IBInspectable var arrowWidth: CGFloat = 200.0
    @IBInspectable var arrowHeight: CGFloat = 200.0
    @IBInspectable var arrowDipHeight: CGFloat = 50
    
    @IBInspectable var leftFillColor: UIColor = UIColor.black
    @IBInspectable var leftStrokeColor: UIColor = UIColor.clear
    @IBInspectable var rightFillColor: UIColor = UIColor.black
    @IBInspectable var rightStrokeColor: UIColor = UIColor.clear
    @IBInspectable var strokeWidth: CGFloat = 3.0
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let arrowOffset = CGPoint(x: rect.origin.x + (rect.width - arrowWidth) / 2, y: rect.origin.y + (rect.height - arrowHeight) / 2)
        
        let arrowRect = CGRect(x: arrowOffset.x, y: arrowOffset.y, width: arrowWidth, height: arrowHeight)
        
        
        // Draw Arrow
        //LeftSide
        let arrowRightSidePath = UIBezierPath()
        arrowRightSidePath.move(to:CGPoint(x: arrowRect.midX, y: arrowRect.origin.y))
        arrowRightSidePath.addLine(to: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY))
        arrowRightSidePath.addLine(to: CGPoint(x: arrowRect.midX, y: arrowRect.maxY - arrowDipHeight))
        arrowRightSidePath.close()
        
        let arrowLeftSidePath = UIBezierPath()
        arrowLeftSidePath.move(to:CGPoint(x: arrowRect.midX, y: arrowRect.origin.y))
        arrowLeftSidePath.addLine(to: CGPoint(x: arrowRect.midX, y: arrowRect.maxY - arrowDipHeight))
        arrowLeftSidePath.addLine(to: CGPoint(x: arrowRect.minX, y: arrowRect.maxY))
        arrowLeftSidePath.close()
        
        //Rotate
        let paths = [arrowLeftSidePath,arrowRightSidePath]
        let fillColors = [leftFillColor, rightFillColor]
        let strokeColors = [leftStrokeColor, rightStrokeColor]
        
        for i in 0..<paths.count  {
            let arrowPath = paths[i]
            let fillColor = fillColors[i]
            let strokeColor = strokeColors[i]
            let bounds = self.bounds
            let center = CGPoint(x:bounds.midX, y:bounds.midY)
            
            let originTranlation =  CGAffineTransform(translationX: -center.x, y: -center.y)
            arrowPath.apply(originTranlation)
            
            let rotationTransform = CGAffineTransform(rotationAngle: -headingAngle)
            arrowPath.apply(rotationTransform)
            
            let scale : CGFloat = 0.7
            let shrinkTransform = CGAffineTransform(scaleX: scale, y: scale)
            arrowPath.apply(shrinkTransform)
            
            let rectifyingTranslation = CGAffineTransform(translationX: center.x, y: center.y)
            arrowPath.apply(rectifyingTranslation)
            
            fillColor.setFill()
            arrowPath.fill()
            
            strokeColor.setStroke()
            arrowPath.lineWidth = strokeWidth
            arrowPath.stroke()
        }
    }

}
