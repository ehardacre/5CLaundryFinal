//
//  shirtAnnotation.swift
//  5CLaundry
//
//  Created by Ethan Hardacre on 7/13/17.
//  Copyright © 2017 5CLaundry. All rights reserved.
//

import UIKit
import MapKit

class shirtAnnotation: MKAnnotationView {
    
    var color = UIColor.blue
    
    func setImage() {
        
        let size = CGSize(width: 50.0, height: 50.0)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        //PATHS
        
        let rect = CGRect(x: 10, y: 2, width: 30, height: 30)
        let buttonPath = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        color.setStroke()
        buttonPath.lineWidth = 2
        buttonPath.stroke()
        UIColor.white.setFill()
        buttonPath.fill()
        
        let pointer = UIBezierPath()
        let startPoint = CGPoint(x: 20, y: 32)
        let midPoint = CGPoint(x: 25, y: 40)
        let endPoint = CGPoint(x: 30, y: 32)
        pointer.move(to: startPoint)
        pointer.addLine(to: midPoint)
        pointer.addLine(to: endPoint)
        pointer.lineWidth = 2
        UIColor.white.setFill()
        pointer.stroke()
        pointer.fill()
        
        let shirt = UIBezierPath()
        let point1 = CGPoint(x: 20, y: 10)
        let point11 = CGPoint(x: 23, y: 10)
        let point12 = CGPoint(x: 25, y: 13)
        let point13 = CGPoint(x: 27, y: 10)
        let point2 = CGPoint(x: 30, y: 10)
        let point3 = CGPoint(x: 35, y: 15)
        let point4 = CGPoint(x: 30, y: 15)
        let point5 = CGPoint(x: 30, y: 25)
        let point6 = CGPoint(x: 20, y: 25)
        let point7 = CGPoint(x: 20, y: 15)
        let point8 = CGPoint(x: 15, y: 15)
        
        shirt.move(to: point1)
        shirt.addLine(to: point11)
        shirt.addLine(to: point12)
        shirt.addLine(to: point13)
        shirt.addLine(to: point2)
        shirt.addLine(to: point3)
        shirt.addLine(to: point4)
        shirt.addLine(to: point5)
        shirt.addLine(to: point6)
        shirt.addLine(to: point7)
        shirt.addLine(to: point8)
        shirt.close()
        
        shirt.stroke()
        color.setFill()
        shirt.fill()
        
        let pointImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = pointImage
    }

}
