//
//  Intro.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/18/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class introViewController: UIViewController, NVActivityIndicatorViewable {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Initialize Spinning Laundry Animation:
        let cellWidth = Int(self.view.frame.width / 2)
        let cellHeight = Int(self.view.frame.height / 2)
        let x = cellWidth
        let y = cellHeight + 20
        let frame = CGRect(x: x-cellWidth/8, y: y+cellHeight/8, width: cellWidth/4, height: cellHeight/4)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 16)!, color: UIColor.white)
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        //Animation lasts for 4 seconds and then performs the segue toHomePage
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            activityIndicatorView.stopAnimating()
            self.performSegue(withIdentifier: "toHomePage", sender: self)
        })
    }
}
