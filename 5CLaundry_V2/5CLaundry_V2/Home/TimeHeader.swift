//
//  TimeHeader.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/23/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

class TimeHeader: UIView {
    
    var label = UILabel()
    var time = false

    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width/2, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = text
        label.sizeToFit()
        self.addSubview(label)
        self.setNeedsDisplay()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setToTime(){
        time = true
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if !time {
            #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).setStroke()
            label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }else{
            #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).setStroke()
            label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 12)
            label.textAlignment = .right
            label.sizeToFit()
        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: label.frame.width + 10, y: 10))
        path.addLine(to: CGPoint(x: rect.width, y: 10))
        path.lineWidth = 2
        path.stroke()
    }
    
}

