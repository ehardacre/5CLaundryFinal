//
//  DryCleaning.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/20/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

/*
 CLASS: Choose a dry cleaning credit amount
 */
class DryCleaning: UIViewController {
    
    //Initialize price strings and corresponding integers
    let prices = ["$50","$100","$200","$300"]
    let price_ints = [50,100,200,300]
    
    /*
     FUNCTION: Required View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set a tinted transparent background
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        //Initialize the view
        initContainer()
    }
    
    /*
     FUNCTION: Initializes the view that contains the information
     */
    func initContainer(){
        //initialize the container
        let container = UIView(frame: CGRect(x: 15, y: view.frame.height/2 - 175, width: view.frame.width - 30, height: 350))
        container.backgroundColor = UIColor(white: 0, alpha: 0.5)
        container.layer.cornerRadius = 15
        
        //initialize the label
        let label = UILabel(frame: CGRect(x: 0, y: 15, width: container.frame.width, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text =
        """
        How much Dry Cleaning Credit
            would you like?
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        container.addSubview(label)
        
        //for each option..
        for price in 0..<prices.count {
            //..Initialize a button with a price label on it
            let credit_one = UIButton(frame: CGRect(x: 15, y: CGFloat(price * 70) + 60, width: container.frame.width - 30, height: 50))
            credit_one.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            credit_one.layer.cornerRadius = 10
            credit_one.tag = price
            let label_one = UILabel(frame: CGRect(x: 0, y: 0, width: credit_one.frame.width, height: 50))
            label_one.text = prices[price]
            label_one.textAlignment = .center
            label_one.font = UIFont.boldSystemFont(ofSize: 20)
            label_one.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            credit_one.addTarget(self, action: #selector(setPrice(sender:)), for: .touchUpInside)
            credit_one.addSubview(label_one)
            container.addSubview(credit_one)
        }
        
        //Initialize the close page button
        let close_button = UIButton(frame: CGRect(x: view.frame.width - 65, y: view.frame.height - 65, width: 50, height: 50))
        close_button.addTarget(self, action: #selector(close_view), for: .touchUpInside)
        let close_image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        close_image.image = #imageLiteral(resourceName: "close")
        close_image.contentMode = .scaleAspectFit
        close_button.addSubview(close_image)
        view.addSubview(close_button)
        view.addSubview(container)
    }
    
    /*
     FUNCTION: Target for each of the buttons in the container
     */
    @objc func setPrice(sender: UIButton){
        //open the payment view
        let popUPVC = Payment()
        popUPVC.setPrice(to: price_ints[sender.tag])
        popUPVC.setPlanDetails(plan: "", semesters: "0" , cleaningCred: "$"+String(price_ints[sender.tag]), bedding: "")
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    /*
     FUNCTION: Target for close button
     */
    @objc func close_view(){
        self.view.removeFromSuperview()
    }

    /*
     FUNCTION: Required Function
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
