//
//  ReviewPurchase.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/20/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

/*
 CLASS: Review a Laundry Plan Purchase
 */
class ReviewPurchase: SubTemplateVC {
    
    //Initialize the responsive price label
    var price_label = UILabel()
    //Initial values for each attribute
    var price = 1
    var plan = ""
    var semesters = 0
    var credit = 0
    var bedding = ""

    /*
     FUNCTION: Required functions
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
     FUNCTION: Initialize the values (Called after the fact)
     */
    func initValues(price: Int, plan: String, credits: Int){
        //Initialize header from SubTemplateVC
        super.initTitle(name: plan)
        
        //price and plan from parameters
        self.price = price
        self.plan = plan
        
        //responsive label indicating the price
        price_label = UILabel(frame: CGRect(x: 0, y: 90, width: self.view.frame.width, height: 100))
        price_label.text = "$" + String(price)
        price_label.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        price_label.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        price_label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        price_label.textAlignment = .center
        self.view.addSubview(price_label)
        
        //Initialize Cleaning credit view
        let clc = CreditView(frame: CGRect(x: 15,y: 260 + (view.frame.height - 190)/6 ,width: view.frame.width - 30 ,height: (view.frame.height - 190)/6), credit: credits, parent: self)
        self.view.addSubview(clc)
        
        //Initialize Bedding view
        let bed = BeddingView(frame: CGRect(x: 15,y: 300 + (view.frame.height - 190)/3 ,width: view.frame.width - 30 ,height: (view.frame.height - 190)/6), parent: self)
        self.view.addSubview(bed)
        
        //Initialize Duration view
        let dur = DurationView(frame: CGRect(x: 15, y: 220, width: view.frame.width - 30, height: (view.frame.height - 190)/6), price_int:price, parent:self, credit:clc, bed: bed)
        self.view.addSubview(dur)
        
        //Initialize the pay button
        let pay = UIButton(frame: CGRect(x: view.frame.width/2 - 100, y: view.frame.height - 100, width: 200, height: 50))
        pay.layer.cornerRadius = 20
        pay.layer.borderWidth = 3
        pay.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pay.addTarget(self, action: #selector(openPayment), for: .touchUpInside)
        //Initialize the label for the pay button
        let pay_label = UILabel(frame: CGRect(x: 0, y: 0, width: pay.frame.width, height: pay.frame.height))
        pay_label.text = "CHECK OUT"
        pay_label.font = UIFont(name: "Avenir Next", size: 18)
        pay_label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        pay_label.textAlignment = .center
        pay.addSubview(pay_label)
        view.addSubview(pay)
    }
    
    /*
     FUNCTION: Target for the pay button
     */
    @objc func openPayment(){
        let popUPVC = Payment()
        popUPVC.setPlanDetails(plan: plan, semesters: String(semesters), cleaningCred: "$"+String(credit), bedding: bedding)
        popUPVC.setPrice(to: price)
        self.addChildViewController(popUPVC)
        popUPVC.view.frame = self.view.frame
        self.view.addSubview(popUPVC.view)
        popUPVC.didMove(toParentViewController: self)
    }
    
    /*
     FUNCTION: Called from the Cleaning Credit view, bedding view, and duration view to update the price
     */
    func setPrice(add: Int, subtract: Int){
        price += add
        price -= subtract
        price_label.text = "$" + String(price)
    }
    
    /*
     FUNCTION: Updates cleaning credit price or bedding price if the number of semesters has changed
     */
    func notifyAll(semester: Int, credit: CreditView, bed: BeddingView){
        credit.setSemester(to: semester)
        bed.setSemester(to: semester)
        semesters = semester
    }
    
    /*
     FUNCTION: Called by cleaning credit view to update credits
     */
    func setCredit(to: Int){
        credit = to
    }
    
    /*
     FUNCTION: Called from bedding view to update price
     */
    func setBedding(to: String){
        bedding = to
    }
    
    /*
     FUNCTION: Required Function
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
 CLASS: Class responsible for changing the duration of the plan
 */
class DurationView : UIView , UIPickerViewDelegate , UIPickerViewDataSource{
    
    //Initializing UI Elements
    var picker = UIPickerView()
    var semester = UILabel()
    var price = UILabel()
    
    //Initializing interaction views
    var cred = CreditView()
    var bed = BeddingView()
    var parent = ReviewPurchase()
    
    //Initializing Starting values
    var choices = ["One","Two"]
    var price_int = 0
    var prev = 0

    /*
     FUNCTION: Blank Initializer
    */
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    /*
     FUNCTION: Initializer with interacting views as parameters
     */
    init(frame : CGRect, price_int: Int, parent: ReviewPurchase, credit:CreditView, bed : BeddingView) {
        super.init(frame: frame)
        
        //Set Up
        self.layer.cornerRadius = 15
        self.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        self.price_int = price_int
        
        //Initializing Interacting views
        self.parent = parent
        self.cred = credit
        self.bed = bed
        
        //Subview to create border effect
        var sub = UIView(frame: CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2))
        sub.layer.cornerRadius = 14
        sub.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(sub)
        
        //Picker for the choices for number of semesters
        picker = UIPickerView(frame: CGRect(x: 10, y: 5, width: sub.frame.width/2 - 15, height: sub.frame.height - 5))
        picker.delegate = self
        picker.dataSource = self
        sub.addSubview(picker)
        
        //Initialize label that identifies the units
        semester = UILabel(frame: CGRect(x: sub.frame.width/2 + 15, y: 15, width: sub.frame.width/2 + 15, height: sub.frame.height - 30))
        semester.text = "Semester"
        semester.font = UIFont(name: "HelveticaNeue", size: 20)
        sub.addSubview(semester)
        
        //Initialize the Header label fro duration view
        var label = UILabel(frame: CGRect(x: 20, y: -10, width: frame.width/5, height: 20))
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Duration"
        label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        label.textAlignment = .center
        self.addSubview(label)
        
        //Initialize the price label of the duration view
        price = UILabel(frame: CGRect(x: self.frame.width - (frame.width/5 + 20), y: self.frame.height - 10, width: frame.width/5, height: 20))
        price.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        price.text = "$" + String(price_int)
        price.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        price.textAlignment = .center
        self.addSubview(price)
    }
    
    /*
     FUNCTIONS: Required for PickerView
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Determines if one one or multiple semesters are selected
        if row == 0 && prev != 0{
            semester.text = "Semester"
            parent.setPrice(add: 0 ,subtract: price_int )
            parent.notifyAll(semester: 1, credit: cred, bed: bed)
            price.text = "$" + String(price_int)
        }else if row == 1 && prev != 1{
            semester.text = "Semesters"
            parent.setPrice(add: price_int ,subtract: 0 )
            parent.notifyAll(semester: 2, credit: cred, bed: bed)
            price.text = "$" + String(2 * price_int)
        }
        prev = row
    }
    
    /*
     FUNCTION: Returns the number of semesters selected
     */
    func getSemester() -> Int{
        print(picker.selectedRow(inComponent: 0)+1)
        return picker.selectedRow(inComponent: 0)+1
    }
    
    /*
     FUNCTION: Required Function
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 CLASS: Cleaning Credit View
 */
class CreditView : UIView , UIPickerViewDelegate , UIPickerViewDataSource{
    
    //UI Elements
    var price_label = UILabel()
    var picker = UIPickerView()
    var semester_label = UILabel()
    
    //Initial Values
    var creditSelected = 0
    var price = 0
    var prev_price = 0
    var choices = [0,50,100,200,300]
    var semester = 1
    
    //Interacting Views
    var parent = ReviewPurchase()
    
    /*
     FUNCTION: Blank Initializer
     */
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    /*
     FUNCTION: Initializer with parameters
     */
    init(frame: CGRect , credit: Int, parent: ReviewPurchase ){
        super.init(frame: frame)
        //UI set up
        self.layer.cornerRadius = 15
        self.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        
        //set parent for interaction
        self.parent = parent
        
        //Subview for border effect
        var sub = UIView(frame: CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2))
        sub.layer.cornerRadius = 14
        sub.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(sub)
        
        //Initialize the picker view
        picker = UIPickerView(frame: CGRect(x: 15, y: 5, width: sub.frame.width/2 - 15, height: sub.frame.height - 5))
        picker.delegate = self
        picker.dataSource = self
        sub.addSubview(picker)
        
        //Initialize the label of the units
        semester_label = UILabel(frame: CGRect(x: sub.frame.width/2 + 15, y: 15, width: sub.frame.width/2 + 15, height: sub.frame.height - 30))
        semester_label.text = "Per Semester"
        semester_label.font = UIFont(name: "HelveticaNeue", size: 20)
        sub.addSubview(semester_label)
        
        //title of the view
        var label = UILabel(frame: CGRect(x: 20, y: -10, width: frame.width/2.5, height: 20))
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Cleaning Credits"
        label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        label.textAlignment = .center
        self.addSubview(label)
        
        //price label for the view
        price_label = UILabel(frame: CGRect(x: self.frame.width - (frame.width/5 + 20), y: self.frame.height - 10, width: frame.width/5, height: 20))
        price_label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        price_label.text = "$" + String(price)
        price_label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        price_label.textAlignment = .center
        self.addSubview(price_label)
    }
    
    /*
     FUNCTION: Required function
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     FUNCTION: Required for UIPickerView Delegate
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "$"+String(choices[row])
    }
    
    /*
     FUNCTION: Updates the price based on the number of semesters selected
     */
    func setSemester(to: Int){
        semester = to
        price = creditSelected * semester
        price_label.text = "$" + String(price)
        parent.setPrice(add: price, subtract: prev_price)
        prev_price = price
    }
    
    /*
     FUNCTION: Responsive price adjustment
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        creditSelected = choices[row]
        parent.setCredit(to: creditSelected)
        price = creditSelected * semester
        price_label.text = "$" + String(price)
        parent.setPrice(add: price, subtract: prev_price)
        prev_price = price
    }
}

/*
 CLASS: View for bedding
 */
class BeddingView : UIView, UIPickerViewDelegate, UIPickerViewDataSource{
    var selected = 0
    var price = 0
    var prev_price = 0
    var price_label = UILabel()
    var picker = UIPickerView()
    var choices = [0,50,100,200]
    var semester_label = UILabel()
    var semester = 1
    var parent = ReviewPurchase()
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    init(frame: CGRect , parent: ReviewPurchase) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        self.parent = parent
        
        var sub = UIView(frame: CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2))
        sub.layer.cornerRadius = 14
        sub.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(sub)
        
        picker = UIPickerView(frame: CGRect(x: 15, y: 5, width: sub.frame.width/2 - 15, height: sub.frame.height - 5))
        picker.delegate = self
        picker.dataSource = self
        sub.addSubview(picker)
        
        semester_label = UILabel(frame: CGRect(x: sub.frame.width/2 + 15, y: 15, width: sub.frame.width/2 + 15, height: sub.frame.height - 30))
        semester_label.text = "Per Semester"
        semester_label.font = UIFont(name: "HelveticaNeue", size: 20)
        sub.addSubview(semester_label)
        
        var label = UILabel(frame: CGRect(x: 20, y: -10, width: frame.width/3, height: 20))
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "Clean Bedding"
        label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        label.textAlignment = .center
        
        price_label = UILabel(frame: CGRect(x: self.frame.width - (frame.width/5 + 20), y: self.frame.height - 10, width: frame.width/5, height: 20))
        price_label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        price_label.text = "$" + String(price)
        price_label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        price_label.textAlignment = .center
        
        self.addSubview(price_label)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String((choices[row]/25)*2) + " Times"
    }
    
    func setSemester(to: Int){
        semester = to
        price = selected * semester
        price_label.text = "$" + String(price)
        parent.setPrice(add: price, subtract: prev_price)
        prev_price = price
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = choices[row]
        price = selected * semester
        price_label.text = "$" + String(price)
        parent.setPrice(add: price, subtract: prev_price)
        parent.setBedding(to: String((selected/25)*2) + " Times")
        prev_price = price
    }
}
