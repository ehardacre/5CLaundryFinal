//
//  Home3.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/24/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import CoreData

class Home3: TemplateVC, UIScrollViewDelegate {
    
    var dates = ["Monday","Wednesday","Friday"]
    var days_in_order : [String] = []
    var preference = [Preference]()
    var managedObjectContext: NSManagedObjectContext!
    var upInd = UIView()
    var downInd = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menu = Menu1(view: self.view, menu_color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), button_color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), home: self)
        self.view.addSubview(menu)

        var frame = menu.getButtonDims()
        var buyPlansButton = UIButton(frame: CGRect(x: 20, y: frame.minY, width: view.frame.width-(frame.width + 60), height: frame.height))
        buyPlansButton.layer.cornerRadius = buyPlansButton.frame.height/2
        buyPlansButton.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        self.view.addSubview(buyPlansButton)
        
        var purchaseLabel = UILabel(frame: CGRect(x: buyPlansButton.frame.width/2 - 50, y: 0, width: 100, height: buyPlansButton.frame.height))
        purchaseLabel.text = "Sign Up"
        purchaseLabel.font = UIFont.boldSystemFont(ofSize: 16)
        purchaseLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        purchaseLabel.textAlignment = .center
        buyPlansButton.addTarget(self, action: #selector(quickBuy), for: .touchUpInside)
        buyPlansButton.addSubview(purchaseLabel)
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let prefRequest : NSFetchRequest<Preference> = Preference.fetchRequest()
        
        do{
            preference = try managedObjectContext.fetch(prefRequest)
        }catch{
            print(error)
        }
        
        let complete = preference.count != 0
        //var recent : Preference = Preference()
        var recent : Preference?
        if complete {
            recent = preference[preference.count - 1]
            setNextStop(stop: (recent?.schoolChosen)!)
            setSchedule()
        }else{
            self.buyPlanPopUp()
            self.showPopUpLoc()
            //setSchedule()
        }
    }
    
    func setAfter(){
        let prefRequest : NSFetchRequest<Preference> = Preference.fetchRequest()
        
        do{
            preference = try managedObjectContext.fetch(prefRequest)
        }catch{
            print(error)
        }
        
        let complete = preference.count != 0
        //var recent : Preference = Preference()
        var recent : Preference?
        if complete {
            recent = preference[preference.count - 1]
            setNextStop(stop: (recent?.schoolChosen)!)
            setSchedule()
        }else{
            setSchedule()
        }
    }
    
    func showPopUpLoc(){
        let popUPVC = LocationChoice()
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    func buyPlanPopUp(){
        let popUPVC = PurchasePopUp()
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    func setNextStop(stop: String){
        
        var nextStop_view = UIView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: 100))
        var title = UILabel(frame: CGRect(x: 0, y: 0, width: nextStop_view.frame.width, height: 20))
        title.text = "Next at Your Location"
        title.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 18)
        nextStop_view.addSubview(title)
        view.addSubview(nextStop_view)
        
        var dayLabel = UILabel(frame: CGRect(x: 0, y: title.frame.height + 10, width: nextStop_view.frame.width, height: 20))
        dayLabel.textAlignment = .center
        dayLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        dayLabel.text = "Today"
        dayLabel.font = UIFont.boldSystemFont(ofSize: 12)
        nextStop_view.addSubview(dayLabel)
        
        if stop != ""{
            
            var stops = [Stop(place:"PITZER", start: "11.00", end: "11.10",half:0),
                     Stop(place:"SCRIPPS", start: "11.15", end: "11.25",half:0),
                     Stop(place:"HMC/SCRIPPS", start: "11.30", end: "11.35",half:0),
                     Stop(place:"POMONA", start: "11.40", end: "11.55",half:0),
                     Stop(place:"CMC/POMONA", start: "12.00", end: "12.15",half:1),
                     Stop(place:"TOWERS", start: "12.20", end: "12.25",half:1),
                     Stop(place:"PITZER", start: "12.30", end: "12.40",half:1),
                     Stop(place:"SCRIPPS", start: "12.45", end: "12.55",half:1),
                     Stop(place:"HMC/SCRIPPS", start: "1.00", end: "1.05",half:1),
                     Stop(place:"POMONA", start: "1.10", end: "1.25",half:1),
                     Stop(place:"CMC/POMONA", start: "1.30", end: "1.45",half:1),
                     Stop(place:"TOWERS", start: "1.50", end: "1.55",half:1)
                     ]
            
            var places = ["PITZER","SCRIPPS","HMC/SCRIPPS","POMONA","CMC/POMONA","TOWERS","PITZER","SCRIPPS","HMC/SCRIPPS","POMONA","CMC/POMONA","TOWERS"]
            var times = ["11:00 - 11:10 am","11:15 - 11:25 am","11:30 - 11:35 am","11:40 - 11:55 am","12:00 - 12:15 pm","12:20 - 12:25 pm","12:30 - 12:40 pm","12:45 - 12:55 pm","1:00 - 1:05 pm","1:10 - 1:25 pm","1:30 - 1:45 pm","1:50 - 1:55 pm"]
            var images = [#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (3)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (4)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (5)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (1)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (2)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (3)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (4)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (5)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (1)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (2)")]
            
            var stops_at_loc : [Stop] = []
            var translated_stop = ""
            print(stop)
            switch stop{
            case "Pomona":
                print(stop)
                translated_stop = "POMONA"
            case "CMC/Pomona North":
                translated_stop = "CMC/POMONA"
            case "Mudd & Scripps":
                translated_stop = "HMC/SCRIPPS"
            case "Pitzer":
                translated_stop = "PITZER"
            case "CMC Towers":
                translated_stop = "TOWERS"
            case "Scripps":
                translated_stop = "SCRIPPS"
            default:
                return
            }
            
            print(stop)
            
            for i in 0..<stops.count{
                if stops[i].place == translated_stop {
                    stops_at_loc += [stops[i]]
                }
            }
            
            
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            var prev = 0
            
            var formatter = DateFormatter()
            formatter.dateFormat = "a"
            let timeOfDay = formatter.string(from: date)
            print(timeOfDay)
            var half = 0
            if timeOfDay == "PM"{
                half = 1
            }
            
        
            var today_int = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
            for i in 0...6{
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
            
            var time_one = stops_at_loc[0]
            var time_two = stops_at_loc[1]
            var nextStop = time_one
            var nextStop_day = days_in_order[0]
            var comparison_one = time_one.compare(hour: hour, min: minutes, half: half)
            var comparison_two = time_two.compare(hour: hour, min: minutes, half: half)
            print("comparison 1: " + String(comparison_one))
            print("comparison 2: " + String(comparison_two))
            if dates.contains(days_in_order[0]){
                if comparison_one == -1{
                    nextStop = time_one
                    nextStop_day = "Today"
                }else if comparison_one == 0{
                    nextStop = time_one
                    nextStop_day = "Today"
                    title.text = "Currently at Your Location"
                }else{
                    if comparison_two == -1{
                        nextStop = time_two
                        nextStop_day = "Today"
                    }else if comparison_two == 0{
                        nextStop = time_two
                        nextStop_day = "Today"
                        title.text = "Currently at Your Location"
                    }else{
                        nextStop = time_one
                        if dates.contains(days_in_order[1]){
                            nextStop_day = days_in_order[1]
                            dayLabel.text = "Tomorrow"
                        }else if dates.contains(days_in_order[2]){
                            nextStop_day = days_in_order[2]
                            dayLabel.text = days_in_order[2]
                        }else{
                            nextStop_day = days_in_order[3]
                            dayLabel.text = days_in_order[3]
                        }
                        
                    }
                }
            }else if dates.contains(days_in_order[1]){
                nextStop = time_one
                nextStop_day = days_in_order[1]
                dayLabel.text = "Tomorrow"
            }else {
                nextStop = time_one
                nextStop_day = days_in_order[2]
                dayLabel.text = nextStop_day
            }
            
            var index = stops.index(of: nextStop)
            var label = TimeHeader(frame: CGRect(x: 15,y: 50 ,width: nextStop_view.frame.width - 30,height: 50), text: times[index!])
            label.setToTime()
            
            var placeImage = UIView(frame: CGRect(x: nextStop_view.frame.width - 55, y: 59, width: 40, height: 40))
            placeImage.layer.borderWidth = 2
            placeImage.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            placeImage.clipsToBounds = true
            placeImage.layer.cornerRadius = 10
            placeImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            var placeImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
            placeImageView.image = images[index!]
            placeImageView.contentMode = .scaleAspectFit
            placeImage.addSubview(placeImageView)
            
            nextStop_view.addSubview(placeImage)
            
            var placeLabel = UILabel(frame: CGRect(x: nextStop_view.frame.width - 155, y: 65, width: 90, height: 20))
            placeLabel.text = places[index!]
            placeLabel.textAlignment = .right
            placeLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            placeLabel.font = UIFont.boldSystemFont(ofSize: 12)
            nextStop_view.addSubview(placeLabel)
            nextStop_view.addSubview(label)
            
            
        }else{
            dayLabel.text = "Go to Settings to set your Delivery Location"
        }
        
    }

    
    func setSchedule(){
        var scheduleView = UIView(frame: CGRect(x: 0, y: 220, width: view.frame.width, height: view.frame.height - 270))
        var title = UILabel(frame: CGRect(x: 0, y: 0, width: scheduleView.frame.width, height: 20))
        title.text = "Schedule"
        title.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 18)
        scheduleView.addSubview(title)
        view.addSubview(scheduleView)
        
        var dayLabel = UILabel(frame: CGRect(x: 0, y: title.frame.height + 10, width: scheduleView.frame.width, height: 20))
        dayLabel.textAlignment = .center
        dayLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        dayLabel.font = UIFont.boldSystemFont(ofSize: 12)
        dayLabel.text = "Monday  Wednesday  Friday"
        scheduleView.addSubview(dayLabel)
        
        var scroller = UIScrollView(frame: CGRect(x: 0, y: title.frame.height + dayLabel.frame.height + 20, width: scheduleView.frame.width, height: scheduleView.frame.height - 100))
        scroller.delegate = self
        
        var scedView = timeView(frame: CGRect(x: 15, y: 0, width: Int(scheduleView.frame.width - 30), height: 670))
        scroller.addSubview(scedView)
        scroller.contentSize = CGSize(width: scheduleView.frame.width, height: scedView.frame.height)
        
        scheduleView.addSubview(scroller)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //TODO add upInd and downInd
    }
    
    @objc func quickBuy(){
        self.transitionTo(cls: "LaundryPlans")
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
        popUPVC.setAttributes(desc: description, email: email)
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }

}

class Menu1 : UIView {
    
    var color_base = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    var menuOpen = false
    
    var dimmingView = UIButton()
    
    var mock : UIView = UIView()
    var button : UIButton = UIButton()
    var view_width: CGFloat = 0,
    view_height: CGFloat = 0,
    menu_vertical_buffer : CGFloat = 0,
    menu_width : CGFloat = 0,
    menu_height : CGFloat = 0,
    button_vertical_buffer : CGFloat = 0,
    button_width : CGFloat = 0,
    tab_section_buffer : CGFloat = 0,
    tab_size : CGFloat = 0,
    tab_vertical_buffer : CGFloat = 0,
    tab_horizontal_buffer : CGFloat = 0
    var pi = CGFloat(Double.pi)
    var home = Home3()
    
    var color_menu = UIColor()
    var color_button = UIColor()
    
    var num_tabs : CGFloat = 4
    var labels = ["Settings", "Laundry Plans", "Contact", "Information"]
    
    var buttonImage = UIImageView()
    
    required init(view: UIView, menu_color : UIColor, button_color : UIColor, home: Home3) {
        super.init(frame: view.frame)
        self.mock = view
        self.home = home
        
        color_menu = menu_color
        color_button = button_color
        
        init_dims()
        init_menu()
        init_button()
        init_tabs()
    }
    
    /*
     Required initializer only called at access from .nib files
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Initializes the dimensions of the views
     */
    func init_dims(){
        view_width = mock.frame.width
        view_height = mock.frame.height
        menu_vertical_buffer = CGFloat(floor(Double(view_height/17.5)))
        menu_width = CGFloat(floor(Double(view_width/2.67)))
        button_vertical_buffer = CGFloat(floor(Double(menu_vertical_buffer/3.6)))
        button_width = menu_width - CGFloat(floor(Double(menu_width/7)))
        menu_height = mock.frame.height - 2*(menu_vertical_buffer)
        
        tab_section_buffer = menu_vertical_buffer * 2
        tab_horizontal_buffer = menu_width/4
        tab_size = menu_width - 2 * (tab_horizontal_buffer)
        tab_vertical_buffer = (menu_height - (4*menu_vertical_buffer) - (tab_size * num_tabs))/num_tabs + 10
        tab_vertical_buffer = CGFloat(floor(Double(tab_vertical_buffer)))
        
    }
    
    /*
     Initializes the menu view
     */
    func init_menu(){
        self.frame = CGRect(x: mock.frame.width,
                            y: menu_vertical_buffer,
                            width: menu_width,
                            height: menu_height)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        dimmingView = UIButton(frame: CGRect(x: 0, y: 0, width: mock.frame.width, height: mock.frame.height))
        dimmingView.addTarget(self, action: #selector(changeMenuState), for: .touchUpInside)
    }
    
    /*s
     Initializes the tabs
     */
    func init_tabs(){
        var pos = tab_section_buffer
        for i in 1...Int(num_tabs){
            let tab = UIButton(frame: CGRect(x: tab_horizontal_buffer,
                                             y: pos, width: tab_size, height: tab_size))
            
            let label = UILabel(frame: CGRect(x: tab_horizontal_buffer - 2.5, y: pos + tab_size - 15, width: tab_size + 5, height: tab_vertical_buffer - 4))
            label.text = labels[i - 1]
            label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 13)
            
            pos = pos + tab_size + tab_vertical_buffer
            tab.layer.cornerRadius = tab_size/2
            tab.backgroundColor = color_menu
            var image = UIImageView(frame: CGRect(x: 10, y: 10, width: tab_size - 20, height: tab_size - 20))
            switch i{
            case 1:
                image.image = #imageLiteral(resourceName: "icons8-settings-filled-50")
                tab.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
            case 2:
                image.image = #imageLiteral(resourceName: "icons8-washing-machine-filled-50")
                tab.addTarget(self, action: #selector(openLaundryPlans), for: .touchUpInside)
            case 3:
                image.image = #imageLiteral(resourceName: "icons8-chat-filled-50")
                tab.addTarget(self, action: #selector(openContact), for: .touchUpInside)
            case 4:
                image.image = #imageLiteral(resourceName: "icons8-info-filled-50 (1)")
                tab.addTarget(self, action: #selector(openInformation), for: .touchUpInside)
            default:
                return
            }
            
            tab.addSubview(image)
            
            self.addSubview(tab)
            self.addSubview(label)
            
        }
    }
    
    @objc func openSettings(){
        self.changeMenuState()
        home.transitionTo(cls: "MyAccount")
    }
    
    @objc func openLaundryPlans(){
        self.changeMenuState()
        home.transitionTo(cls: "LaundryPlans")
    }
    
    @objc func openContact(){
        self.changeMenuState()
        home.transitionTo(cls: "Contact")
    }
    
    @objc func openInformation(){
        self.changeMenuState()
        home.transitionTo(cls: "Information")
    }
    
    /*
     Initializes the button that opens the menu
     */
    func init_button(){
        button = UIButton(frame: CGRect(x: mock.frame.width - menu_width,
                                        y: mock.frame.height - (menu_vertical_buffer + (2 * button_vertical_buffer)),
                                        width: button_width,
                                        height: menu_vertical_buffer))
        button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
        button.layer.cornerRadius = button.frame.height/2
        button.addTarget(self, action: #selector(changeMenuState), for: .touchUpInside)
        buttonImage = UIImageView(frame: CGRect(x: button.frame.width/2 - 15, y: button.frame.height/2 - 15, width: 30, height: 30))
        buttonImage.image = #imageLiteral(resourceName: "icons8-menu-filled-50")
        buttonImage.contentMode = .scaleAspectFit
        button.addSubview(buttonImage)
        mock.addSubview(button)
    }
    
    func getButtonDims() -> CGRect {
        return CGRect(x: mock.frame.width - menu_width, y: mock.frame.height - (menu_vertical_buffer + (2 * button_vertical_buffer)), width: button_width, height: menu_vertical_buffer)
    }
    
    /*
     Target of the button/
     Actions that occur upon opening the menu
     */
    @objc func changeMenuState(){
        if menuOpen {
            UIView.animate(withDuration: 0.1, animations: {
                self.frame = CGRect(x: self.mock.frame.width,
                                    y: self.menu_vertical_buffer,
                                    width: self.menu_width,
                                    height: self.mock.frame.height - 2*(self.menu_vertical_buffer))
                self.dimmingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
                self.button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
                self.buttonImage.image = #imageLiteral(resourceName: "icons8-menu-filled-50")
            })
            dimmingView.removeFromSuperview()
            self.menuOpen = false
        }else{
            mock.addSubview(dimmingView)
            UIView.animate(withDuration: 0.1, animations: {
                self.frame = CGRect(x: self.mock.frame.width - self.menu_width,
                                    y: self.menu_vertical_buffer,
                                    width: self.menu_width,
                                    height: self.mock.frame.height - 2*(self.menu_vertical_buffer))
                self.dimmingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
                self.button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.buttonImage.image = #imageLiteral(resourceName: "icons8-multiply-filled-50 (1)")
            })
            self.menuOpen = true
            mock.bringSubview(toFront: self)
            mock.bringSubview(toFront: button)
        }
    }
    
    /*
     remove from superview also removes the menu button from the mock
     */
    override func removeFromSuperview() {
        button.removeFromSuperview()
        super.removeFromSuperview()
    }
    
    /*
     redraw the menu for fancy curves
     */
    override func draw(_ rect: CGRect) {
        let BR = CGPoint(x: frame.width,
                         y: frame.height)
        let TR = CGPoint(x: frame.width,
                         y: 0.0)
        let anchorOne = CGPoint(x: BR.x - menu_vertical_buffer,
                                y: BR.y)
        let anchorTwo = CGPoint(x: 0.0 + menu_vertical_buffer,
                                y: BR.y - (2*menu_vertical_buffer))
        let anchorThree = CGPoint(x: 0.0 + menu_vertical_buffer ,
                                  y: 0.0 + (2*menu_vertical_buffer))
        let anchorFour = CGPoint(x: TR.x - menu_vertical_buffer,
                                 y: 0.0)
        
        let path = UIBezierPath()
        path.move(to: BR)
        path.addArc(withCenter: anchorOne,
                    radius: menu_vertical_buffer,
                    startAngle: 0,
                    endAngle: 3*pi/2,
                    clockwise: false)
        path.addLine(to: CGPoint(x: anchorTwo.x,
                                 y: anchorTwo.y + 38))
        path.addArc(withCenter: anchorTwo,
                    radius: menu_vertical_buffer,
                    startAngle: 3*pi/2,
                    endAngle: pi,
                    clockwise: true)
        path.addLine(to: CGPoint(x: 0.0,
                                 y: anchorThree.y))
        path.addArc(withCenter: anchorThree,
                    radius: menu_vertical_buffer,
                    startAngle: pi,
                    endAngle: 3*pi/2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: anchorFour.x,
                                 y: anchorFour.y + menu_vertical_buffer))
        path.addArc(withCenter: anchorFour,
                    radius: menu_vertical_buffer,
                    startAngle: pi/2,
                    endAngle: 0.0,
                    clockwise: false)
        path.close()
        color_menu.setFill()
        path.fill()
    }
    
    
}

class timeView : UIView {
    
    var places = ["PITZER","SCRIPPS","HMC/SCRIPPS","POMONA","CMC/POMONA","TOWERS","PITZER","SCRIPPS","HMC/SCRIPPS","POMONA","CMC/POMONA","TOWERS"]
    var times = ["11:00 - 11:10 am","11:15 - 11:25 am","11:30 - 11:35 am","11:40 - 11:55 am","12:00 - 12:15 pm","12:20 - 12:25 pm","12:30 - 12:40 pm","12:45 - 12:55 pm","1:00 - 1:05 pm","1:10 - 1:25 pm","1:30 - 1:45 pm","1:50 - 1:55 pm"]
    var images = [#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (3)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (4)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (5)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (1)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (2)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (3)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (4)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (5)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (1)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (2)")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setLabels()
    }
    
    func setLabels(){
        var placement = 0
        for i in 0..<12{
            var time = TimeHeader(frame: CGRect(x: 0, y: placement, width: Int(self.frame.width), height: 50), text: times[i])
            time.setToTime()
            var placeImage = UIView(frame: CGRect(x: self.frame.width - 40, y: 9, width: 40, height: 40))
            placeImage.layer.borderWidth = 2
            placeImage.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            placeImage.clipsToBounds = true
            placeImage.layer.cornerRadius = 10
            placeImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            var placeImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
            placeImageView.image = images[i]
            placeImageView.contentMode = .scaleAspectFit
            placeImage.addSubview(placeImageView)
            
            time.addSubview(placeImage)
            
            var placeLabel = UILabel(frame: CGRect(x: self.frame.width - 140, y: 15, width: 90, height: 20))
            placeLabel.text = places[i]
            placeLabel.textAlignment = .right
            placeLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            placeLabel.font = UIFont.boldSystemFont(ofSize: 12)
            time.addSubview(placeLabel)
            
            placement += 55
            self.addSubview(time)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class Confirmation: UIViewController {
    
    var close_button = UIButton()
    var close = UIImageView()
    
    var desc = ""
    var email = ""
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        var container = UIView(frame: CGRect(x: 30, y: view.frame.height/2 - 150, width: view.frame.width - 60, height: 230))
        container.backgroundColor = UIColor(white: 0, alpha: 0.7)
        container.layer.cornerRadius = 15
        self.view.addSubview(container)
        
        var image_confirmation = UIImageView(frame: CGRect(x: container.frame.width/2 - 40, y: 15, width: 80, height: 80))
        image_confirmation.image = #imageLiteral(resourceName: "confirmation")
        image_confirmation.contentMode = .scaleAspectFit
        container.addSubview(image_confirmation)
        
        var label_confirmation = UILabel(frame: CGRect(x: 15, y: 105, width: container.frame.width - 30, height: 30))
        label_confirmation.text = "Purchase Complete"
        label_confirmation.font = UIFont.boldSystemFont(ofSize: 20)
        label_confirmation.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label_confirmation.textAlignment = .center
        container.addSubview(label_confirmation)
        
        close_button = UIButton(frame: CGRect(x: container.frame.width - 65, y: container.frame.height - 65, width: 50, height: 50))
        close = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        close.image = #imageLiteral(resourceName: "close")
        close.contentMode = .scaleAspectFit
        close_button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        close_button.addSubview(close)
        container.addSubview(close_button)
        
//        var emailButton = UIButton(frame: CGRect(x: 30, y: container.frame.height - 55, width: container.frame.width - 110, height: 30))
//        emailButton.layer.cornerRadius = 10
//        emailButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        var emailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: emailButton.frame.width, height: 30))
//        emailLabel.textAlignment = .center
//        emailLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//        emailLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        emailLabel.text = "Email Receipt"
//        emailButton.addSubview(emailLabel)
//        emailButton.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
//        container.addSubview(cemailButton)
    }
    
    func setAttributes(desc: String, email: String){
        self.desc = desc
        self.email = email
    }
    
    @objc func closeAction(){
        view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

