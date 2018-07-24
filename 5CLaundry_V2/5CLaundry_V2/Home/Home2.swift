//
//  Home2.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/23/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

class Home2: TemplateVC , UIScrollViewDelegate{
    
    var scheduleView = UIScrollView()
    var dates = ["Monday","Wednesday","Friday"]
    var day_views : [UILabel] = []
    var currentDay = UILabel()
    var days_in_order : [String] = []
    
    var activeHead = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var menu = Menu1(view: self.view, menu_color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), button_color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), home: self)
//        self.view.addSubview(menu)
        
        var label = UILabel(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: 30))
        label.text = "Delivery and Pick-Up"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(label)
        
        var label_sub = UILabel(frame: CGRect(x: 0, y: 145, width: view.frame.width, height: 32))
        label_sub.text = "SCHEDULE"
        label_sub.font = UIFont.boldSystemFont(ofSize: 32)
        label_sub.textAlignment = .center
        label_sub.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(label_sub)
        
        scheduleView = UIScrollView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 280))
        scheduleView.delegate = self
        scheduleView.showsVerticalScrollIndicator = false
        setScrollView()
        
        self.view.addSubview(scheduleView)
        
//        var frame = menu.getButtonDims()
//        var buyPlansButton = UIButton(frame: CGRect(x: 20, y: frame.minY, width: view.frame.width-(frame.width + 60), height: frame.height))
//        buyPlansButton.layer.cornerRadius = buyPlansButton.frame.height/2
//        buyPlansButton.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
//        self.view.addSubview(buyPlansButton)
//
//        var purchaseLabel = UILabel(frame: CGRect(x: buyPlansButton.frame.width/2 - 50, y: 0, width: 100, height: buyPlansButton.frame.height))
//        purchaseLabel.text = "View Plans"
//        purchaseLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        purchaseLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        purchaseLabel.textAlignment = .center
//        buyPlansButton.addTarget(self, action: #selector(quickBuy), for: .touchUpInside)
//        buyPlansButton.addSubview(purchaseLabel)
    }
    
    @objc func quickBuy(){
        self.transitionTo(cls: "LaundryPlans")
    }
    
    func setScrollView(){
        
        scheduleView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
        
        var today_int = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        for i in 0...6{
            print((i + today_int)%7)
            switch (i + today_int)%7{
            case 0:
                days_in_order += ["Sunday"]
            case 1:
                days_in_order += ["Monday"]
            case 2:
                days_in_order += ["Tuesday"]
            case 3:
                days_in_order += ["Wednesday"]
            case 4:
                days_in_order += ["Thursday"]
            case 5:
                days_in_order += ["Friday"]
            case 6:
                days_in_order += ["Saturday"]
            default:
                return
            }
        }
        var placement = 15
        for i in 1...7{
            if i == 1 {
                var today = UILabel(frame: CGRect(x: 15, y: placement ,width: Int(scheduleView.frame.width-30) ,height: 20))
                today.text = "Today"
                today.font = UIFont.boldSystemFont(ofSize: 16)
                today.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                scheduleView.addSubview(today)
                placement += 25
                if !dates.contains(days_in_order[i-1]) {
                    var label = UILabel(frame: CGRect(x:Int(scheduleView.frame.width/3 - 30), y: placement, width: Int(scheduleView.frame.width/3*2), height: 20))
                    label.text = "There are no stops scheduled for today."
                    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    label.font = UIFont.systemFont(ofSize: 12)
                    scheduleView.addSubview(label)
                    placement += 50
                }else{
                    var scedView = timeView(frame: CGRect(x: Int(scheduleView.frame.width/3 - 30), y: placement, width: Int(scheduleView.frame.width/3*2), height: 670))
                    placement += 675
                    scheduleView.addSubview(scedView)
                }
                day_views += [today]
            }else if i == 2{
                var tomorrow = UILabel(frame: CGRect(x: 15, y: placement , width: Int(scheduleView.frame.width-30) ,height: 20))
                tomorrow.text = "Tomorrow"
                tomorrow.font = UIFont.boldSystemFont(ofSize: 16)
                tomorrow.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                scheduleView.addSubview(tomorrow)
                placement += 25
                if !dates.contains(days_in_order[i-1]) {
                    var label = UILabel(frame: CGRect(x:Int(scheduleView.frame.width/3 - 30), y: placement, width: Int(scheduleView.frame.width/3*2), height: 20))
                    label.text = "There are no stops scheduled for today."
                    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    label.font = UIFont.systemFont(ofSize: 12)
                    scheduleView.addSubview(label)
                    placement += 50
                }else{
                    var scedView = timeView(frame: CGRect(x: Int(scheduleView.frame.width/3 - 30), y: placement, width: Int(scheduleView.frame.width/3*2), height: 670))
                    placement += 675
                    scheduleView.addSubview(scedView)
                }
                day_views += [tomorrow]
            }else{
                var day = UILabel(frame: CGRect(x: 15, y: placement , width: Int(scheduleView.frame.width-30) ,height: 20))
                day.text = days_in_order[i-1]
                day.font = UIFont.boldSystemFont(ofSize: 16)
                day.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                scheduleView.addSubview(day)
                placement += 25
                if !dates.contains(days_in_order[i-1]) {
                    var label = UILabel(frame: CGRect(x:Int(scheduleView.frame.width/3 - 30), y: placement, width: Int(scheduleView.frame.width/3*2), height: 20))
                    label.text = "There are no stops scheduled for today."
                    label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    label.font = UIFont.systemFont(ofSize: 12)
                    scheduleView.addSubview(label)
                    placement += 50
                }else{
                    var scedView = timeView(frame: CGRect(x: Int(scheduleView.frame.width/3 - 30), y: placement, width: Int(scheduleView.frame.width/3*2), height: 670))
                    placement += 675
                    scheduleView.addSubview(scedView)
                }
                day_views += [day]
                
            }
            
        }
        scheduleView.contentSize = CGSize(width: scheduleView.frame.width, height: CGFloat(placement + 50))
        
        currentDay = UILabel(frame: CGRect(x: 15, y: Int(scheduleView.frame.minY - 20), width: Int(scheduleView.frame.width-30), height: 20))
        currentDay.font = UIFont.boldSystemFont(ofSize: 16)
        currentDay.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(currentDay)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0...6{
            var replacementView = UIView()
            var day = day_views[i]
            if day_views[i].frame.minY + 20 <= scrollView.contentOffset.y  {
                if i == 0{
                    currentDay.text = "Today"
                }else if i == 1{
                    currentDay.text = "Tomorrow"
                }else{
                    currentDay.text = days_in_order[i]
                }
                activeHead = i
            }
            if day_views[0].frame.maxY >= scrollView.contentOffset.y && activeHead != -1{
                currentDay.text = ""
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionTo(cls : String){
        let myClass = createClassFrom(name: cls) as! UIViewController.Type
        let instance = myClass.init()
        self.addChildViewController(instance)
        instance.view.frame = self.view.frame
        self.view.addSubview(instance.view)
        instance.didMove(toParentViewController: self)
    }
    
    func createClassFrom(name: String) -> AnyClass{
        //let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls : AnyClass = NSClassFromString("_CLaundry_V2.\(name)")!
        return cls
    }
    
    func confirmPayment(description: String, email: String){
        let popUPVC = Confirmation()
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }

}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}


