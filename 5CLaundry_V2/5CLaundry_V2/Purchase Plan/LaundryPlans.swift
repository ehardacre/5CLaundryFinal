//
//  LaundryPlans.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/19/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

/*
 CLASS: THe view controller for the scroll view of laundry plans
 */
class LaundryPlans: SubTemplateVC, UIScrollViewDelegate{
    
    //initialize the scrollview and the page control
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    
    //initialize the plans, prices and other info
    var plans = ["STAY CLEAN","LOOK SHARP","DELUXE","PAY AS YOU GO","DRY CLEAN"]
    var prices = ["$229","$399","$549","$2"]
    var per = ["per semester","per semester","per semester","per pound"]
    var purchase = ["SIGN UP!","SIGN UP!","SIGN UP!","REGISTER!","BUY CREDIT!"]
    var pounds = [10,5,20]
    var turnaround = [48,48,48]
    var additional = [1.75,1.75,1.50]

    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize the header from SubtemplateV
        super.initTitle(name: "Laundry Plans")
        
        //configure the page control
        configurePageControl()
        
        //Initialize scroll view properties
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 90, width: view.frame.width, height: view.frame.height - 90))
        scrollView.contentSize.width = view.frame.width * CGFloat(plans.count)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        //Apply for for each plan
        for index in 0..<plans.count{
            //Initialize a laundry plan view
            let page = LaundryPlan(frame: CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height - 70))
            page.setTitle(text: plans[index])
            scrollView.addSubview(page)
            
            //Initialize the purchase button
            let purchase_button = UIButton(frame: CGRect(x: view.frame.width * CGFloat(index) + (view.frame.width/2 - 100), y: view.frame.height - 200, width: 200, height: 50))
            purchase_button.layer.cornerRadius = 20
            purchase_button.layer.borderWidth = 3
            purchase_button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            //Initialize the label for the purchase button
            let button_label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            button_label.text = purchase[index]
            button_label.font = UIFont(name: "Avenir Next", size: 18)
            button_label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            button_label.textAlignment = .center
            purchase_button.addSubview(button_label)
            scrollView.addSubview(purchase_button)
            
            //Dry cleaning requires different operations
            if (plans[index] != "DRY CLEAN" && plans[index] != "PAY AS YOU GO"){
                
                //Add different targets to buttons depending on the type of plan being purchased
                switch plans[index] {
                case "LOOK SHARP":
                    purchase_button.addTarget(self, action: #selector(reviewLookSharp), for: .touchUpInside)
                case "STAY CLEAN":
                    purchase_button.addTarget(self, action: #selector(reviewStayClean), for: .touchUpInside)
                case "DELUXE":
                    purchase_button.addTarget(self, action: #selector(reviewDeluxe), for: .touchUpInside)
                default:
                    return
                }
                
                //The label that indicates the price of the plan
                let price_label = UILabel(frame: CGRect(x: view.frame.width * CGFloat(index), y: 100, width: view.frame.width, height: 60))
                price_label.textAlignment = .center
                price_label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                price_label.text = prices[index]
                price_label.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
                scrollView.addSubview(price_label)
                
                //The label that goes below the price to indicat the unit charged
                let per_label = UILabel(frame: CGRect(x: view.frame.width * CGFloat(index), y: 140, width: view.frame.width, height: 40))
                per_label.textAlignment = .center
                per_label.text = per[index]
                per_label.font = UIFont(name: "HelveticaNeue", size: 12)
                scrollView.addSubview(per_label)
                
                //the frame for additional info
                let info = UIView(frame: CGRect(x: view.frame.width * CGFloat(index) + 40, y: 180, width: view.frame.width - 80, height: 250))
                info.layer.cornerRadius = 20
                info.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
                info.layer.borderWidth = 3
                scrollView.addSubview(info)
                
                //Pay as you go requires different treatment
                    //the label for the infobits not in pay as you go
                let infobit = UILabel(frame: CGRect(x: 0, y: 0, width: info.frame.width, height: info.frame.height))
                infobit.text = """
                     ● \(pounds[index]) pounds per week
                    
                     ● \(turnaround[index]) hour turnaround
                    
                     ● $\(additional[index]) per additional pound
                    """
                infobit.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                infobit.textAlignment = .center
                infobit.numberOfLines = 0
                info.addSubview(infobit)
                
            }else if plans[index] == "PAY AS YOU GO"{ //pay as you go
                purchase_button.addTarget(self, action: #selector(reviewPayAsYouGo), for: .touchUpInside)
                
                //The label that indicates the price of the plan
                let price_label = UILabel(frame: CGRect(x: view.frame.width * CGFloat(index), y: 120, width: view.frame.width, height: 60))
                price_label.textAlignment = .center
                price_label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                price_label.text = "Want service as needed?" //prices[index]
                price_label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                scrollView.addSubview(price_label)
                
                //The label that goes below the price to indicat the unit charged
//                let per_label = UILabel(frame: CGRect(x: view.frame.width * CGFloat(index), y: 140, width: view.frame.width, height: 40))
//                per_label.textAlignment = .center
//                per_label.text = per[index]
//                per_label.font = UIFont(name: "HelveticaNeue", size: 12)
//                scrollView.addSubview(per_label)
                
                //the frame for additional info
                let info = UIView(frame: CGRect(x: view.frame.width * CGFloat(index) + 40, y: 180, width: view.frame.width - 80, height: 250))
                info.layer.cornerRadius = 20
                info.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
                info.layer.borderWidth = 3
                scrollView.addSubview(info)
                
                //Initializing the labels for the pay as you go plan
                let infobitOne = UILabel(frame: CGRect(x: 0, y: info.frame.height/8, width: info.frame.width, height: info.frame.height/8))
                infobitOne.text = """
                Give us your info and
                """
                infobitOne.textAlignment = .center
                infobitOne.numberOfLines = 1
                info.addSubview(infobitOne)
                
                let infobitTwo = UILabel(frame: CGRect(x: 0, y: infobitOne.frame.maxY, width: info.frame.width, height: info.frame.height/8))
                infobitTwo.text = """
                Pay As You Go!
                """
                infobitTwo.textAlignment = .center
                infobitTwo.numberOfLines = 1
                infobitTwo.font = UIFont.boldSystemFont(ofSize: 17)
                info.addSubview(infobitTwo)
                
                let infobitThree = UILabel(frame: CGRect(x: 0, y: info.frame.height/2, width: info.frame.width, height: info.frame.height/8))
                infobitThree.text = """
                $2/pound
                """
                infobitThree.textAlignment = .center
                infobitThree.numberOfLines = 1
                info.addSubview(infobitThree)
                
            
            }else if plans[index] == "DRY CLEAN"{ //DryCleaning
                //Adding the target for the purchase button
                purchase_button.addTarget(self, action: #selector(dryCleaning), for: .touchUpInside)
                
                //Initializing info view for dry cleaning
                let info = UIView(frame: CGRect(x: view.frame.width * CGFloat(index) + 40, y: 110, width: view.frame.width - 80, height: view.frame.height - 350))
                info.layer.cornerRadius = 20
                info.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
                info.layer.borderWidth = 3
                scrollView.addSubview(info)
                
                //initialziing the lists for drycleaning information
                var clothes = ["Pants","Shirt/Blouse", "Sport Coat", "Sweater", "Suit",
                               "Uniform" ,"Lined/Silk Blouse" , "Dress", "Suit and Skirt","Skirt"]
                // 0 = both, 1 = men, 2 = women
                var sex = [0,0,1,1,1,1,2,2,2,2]
                var prices = ["$4","$4","$6","$5+","$10","$5","$5","$8+","$10","$6"]
                
                //apply for each item of clothing
                for cloth in 0..<clothes.count{
                    //initialize the clothing label
                    let rect = CGRect(x: 10, y: ((info.frame.height - 20)/10)*CGFloat(cloth) + 10, width: info.frame.width/2 - 10, height: (info.frame.height - 20)/10)
                    let row = UILabel(frame: rect)
                    row.textAlignment = .right
                    row.text = clothes[cloth]
                    info.addSubview(row)
                    
                    //Initialize the dry cleaning pricetag for that item
                    let price_rect = CGRect(x: info.frame.width/2 + 10,
                                            y: ((info.frame.height - 20)/10)*CGFloat(cloth) + 10 + 5,
                                            width: ((info.frame.height - 20)/10 - 10)*2,
                                            height: (info.frame.height - 20)/10 - 10)
                    let price = priceTag(frame: price_rect, price: prices[cloth])
                    info.addSubview(price)
                    
                    //determing for which sex this item of clothing applies
                    if sex[cloth] == 0{
                        //Initialize a mens tag and womens tag
                        let mens = MensTag(frame: CGRect(
                            x: info.frame.width/2 + ((info.frame.height - 20)/10 - 10)*2 + 15,
                            y: ((info.frame.height - 20)/10)*CGFloat(cloth) + 10 + 5,
                            width: (info.frame.height - 20)/10 - 10,
                            height: (info.frame.height - 20)/10 - 10))
                        let womens = WomensTag(frame: CGRect(
                            x: info.frame.width/2 + ((info.frame.height - 20)/10 - 10)*3 + 20,
                            y: ((info.frame.height - 20)/10)*CGFloat(cloth) + 10 + 5,
                            width: (info.frame.height - 20)/10 - 10,
                            height: (info.frame.height - 20)/10 - 10))
                        info.addSubview(mens)
                        info.addSubview(womens)
                    }else if sex[cloth] == 1{
                        //Initialize a mens tag
                        let mens = MensTag(frame: CGRect(
                            x: info.frame.width/2 + ((info.frame.height - 20)/10 - 10)*2 + 15,
                            y: ((info.frame.height - 20)/10)*CGFloat(cloth) + 10 + 5,
                            width: (info.frame.height - 20)/10 - 10,
                            height: (info.frame.height - 20)/10 - 10))
                        info.addSubview(mens)
                    }else{
                        //Initialize a womens tag
                        let womens = WomensTag(frame: CGRect(
                            x: info.frame.width/2 + ((info.frame.height - 20)/10 - 10)*2 + 15,
                            y: ((info.frame.height - 20)/10)*CGFloat(cloth) + 10 + 5,
                            width: (info.frame.height - 20)/10 - 10,
                            height: (info.frame.height - 20)/10 - 10))
                        info.addSubview(womens)
                    }
                }
            }
        }
        view.addSubview(scrollView)
    }
    
    /*
     FUNCTION: Target for the DryCleaning Puchase Button
    */
    @objc func dryCleaning(){
        let popUPVC = DryCleaning()
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    /*
     FUNCTION: Target for the Look Sharp Puchase Button
     */
    @objc func reviewLookSharp(){
        let popUPVC = ReviewPurchase()
        popUPVC.initValues(price: 349, plan: "Look Sharp", credits: 0)
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    /*
     FUNCTION: Target for the Stay Clean Puchase Button
     */
    @objc func reviewStayClean(){
        let popUPVC = ReviewPurchase()
        popUPVC.initValues(price: 199, plan: "Stay Clean", credits: 0)
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    /*
     FUNCTION: Target for the Deluxe Puchase Button
     */
    @objc func reviewDeluxe(){
        let popUPVC = ReviewPurchase()
        popUPVC.initValues(price: 499, plan: "Deluxe", credits: 0)
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    /*
     FUNCTION: Target for the Pay as you go Puchase Button
     */
    @objc func reviewPayAsYouGo(){
        let popUPVC = Payment()
        popUPVC.setPlanDetails(plan: "PAY AS YOU GO", semesters: "0", cleaningCred: "", bedding: "")
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
        popUPVC.addPayAsYouGo()
    }
    
    /*
     FUNCTION: Initializes the page control
     */
    func configurePageControl() {
        //Initialize UIPageControl
        pageControl = UIPageControl(frame: CGRect(x: view.frame.width/2 - 150, y: view.frame.height - 50, width: 300, height: 50))
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        pageControl.numberOfPages = plans.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)
    }
    
    /*
     FUNCTION: Triggered when scroll view finishes scrolling
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //change the page number of the page control
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    /*
     FUNCTION: Required View Controller function
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
 CLASS: Manages the view of a laundry plan page
 */
class LaundryPlan : UIView {
    
    //Initialize the title label
    var title = UILabel()
    
    /*
     FUNCTION: Initializer
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Initialize the title label and attributes
        title = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        title.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        title.textAlignment = .center
        self.addSubview(title)
    }
    
    /*
     FUNCTION: set the title after the fact
     */
    func setTitle(text: String){
        title.text = text
    }
    
    /*
     FUNCTION: Required function
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

/*
 CLASS: the mens tag class for dry cleaning items
 UPDATE: merge with womens tag
 */
class MensTag : UILabel {
    
    /*
     FUNCTION: Initializer
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height/4
        self.text = "M"
        self.textAlignment = .center
        self.textColor = UIColor.white
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    /*
     FUNCTION: Required function
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 CLASS: the womens tag class for dry cleaning items
 UPDATE: merge with mens tag
 */
class WomensTag: UILabel {
    
    /*
     FUNCTION: Initializer
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height/4
        self.text = "W"
        self.textAlignment = .center
        self.textColor = UIColor.white
        self.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        self.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    /*
     FUNCTION: Required Function
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/*
 CLASS: The pricetag on dry cleaning items
 */
class priceTag: UILabel {
    init(frame: CGRect, price: String) {
        super.init(frame: frame)
        self.text = price
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.font = UIFont.boldSystemFont(ofSize: 12)
        self.layer.cornerRadius = 5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
