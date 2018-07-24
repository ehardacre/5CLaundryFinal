//
//  Payment.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/21/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import Foundation
import Stripe
import CreditCardForm
import Alamofire
import NVActivityIndicatorView
import CoreData

class Payment: UIViewController , STPPaymentCardTextFieldDelegate , UIScrollViewDelegate, UITextFieldDelegate{
    
    //let stripePublishableKey = "pk_live_SX3p13o4u7n9zhTTaG42Zew0"
    let stripePublishableKey = "pk_test_rLt6nHx2dgbewvBUXWAWrQxF"
    
    let backendBaseURL: String? = "https://still-brushlands-35459.herokuapp.com/charge.php"
    
    let paymentTextField = STPPaymentCardTextField()
    let card = CreditCardFormView()
    
    var baseView = UIView()
    var seqView = UIScrollView()
    var confirm_button = UIButton()
    var close_button = UIButton()
    var confirm = UIImageView()
    var close = UIImageView()
    
    var price = 1
    var price_label = UILabel()
    var note_lab = UILabel()
    
    var pageControl = UIPageControl()
    
    var name_label = UITextField()
    var phone_label = UITextField()
    var email_label = UITextField()
    var confirmButton = UIButton()
    var errorView = UIView()
    var cardValid = false
    var keyboardAssist = UIButton()
    var deleting = false
    
    var studentName = ""
    var studentphoneNumber = ""
    var studentemail = ""
    
    var pay_label = UILabel()
    
    
    //New stuff for payment
        var managedObjectContext: NSManagedObjectContext!
    
        var resultDate = ""
    
        var planDetails = ""
    
        var laundryPlan = ""
    
        var purchaseDescription = ""
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        setObjectContext()
        
        setViews()
        configurePageControl()
        seqView.delegate = self
        seqView.showsHorizontalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setObjectContext(){
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        resultDate = formatter.string(from: date)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            UIView.animate(withDuration: 0.5, animations: {
                self.keyboardAssist.frame.origin.y -= (keyboardSize.height + self.keyboardAssist.frame.height)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            UIView.animate(withDuration: 0.5, animations: {
                self.keyboardAssist.frame.origin.y += (keyboardSize.height + self.keyboardAssist.frame.height)
            })
        }
    }

    //sets up the views
    func setViews(){
        
        
        baseView = UIView(frame: CGRect(x: 15, y: 15, width: view.frame.width - 30, height: view.frame.height - 100))
        baseView.layer.cornerRadius = 15
        baseView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(baseView)
        
        close_button = UIButton(frame: CGRect(x: view.frame.width - 65, y: view.frame.height - 65, width: 50, height: 50))
        close = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        close.image = #imageLiteral(resourceName: "close")
        close.contentMode = .scaleAspectFit
        close_button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        close_button.addSubview(close)
        view.addSubview(close_button)
        
        var header = UIView(frame: CGRect(x: 0, y: 0, width: baseView.frame.width, height: 100))
        header.clipsToBounds = true
        header.layer.cornerRadius = 15
        header.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        header.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        baseView.addSubview(header)
        
        seqView = UIScrollView(frame: CGRect(x: 0, y: header.frame.height, width: baseView.frame.width, height: baseView.frame.height - header.frame.height))
        seqView.contentSize = CGSize(width: baseView.frame.width * 2, height: seqView.frame.height)
        seqView.isPagingEnabled = true
        seqView.backgroundColor = UIColor.clear
        baseView.addSubview(seqView)
        
        var price_label = UILabel(frame: CGRect(x: 0, y: 0, width: header.frame.width, height: header.frame.height))
        price_label.text = "$"+String(price)
        price_label.font = UIFont.boldSystemFont(ofSize: 20)
        price_label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        price_label.textAlignment = .center
        header.addSubview(price_label)
        
        note_lab = UILabel(frame: CGRect(x: 10, y: 5, width: header.frame.width - 20, height: 50))
        note_lab.numberOfLines = 0
        note_lab.textAlignment = .center
        note_lab.font = UIFont.systemFont(ofSize: 10)
        seqView.addSubview(note_lab)
        
        card.frame =  CGRect(x: 15, y: 60, width: baseView.frame.width - 30, height: (baseView.frame.width - 30)/3*2 - 30)
        seqView.addSubview(card)
        
        paymentTextField.frame = CGRect(x: 15, y: baseView.frame.height/2 - 40, width: baseView.frame.width - 30, height: 40)
        paymentTextField.delegate = self
        seqView.addSubview(paymentTextField)
        
        name_label = UITextField(frame: CGRect(x: baseView.frame.width + 15, y: 60 , width: baseView.frame.width - 30, height: 40))
        name_label.layer.cornerRadius = 5
        name_label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        name_label.layer.borderWidth = 2
        name_label.placeholder = "Full Name"
        name_label.textAlignment = .center
        name_label.autocorrectionType = .no
        seqView.addSubview(name_label)
        
        phone_label = UITextField(frame: CGRect(x: baseView.frame.width + 15, y: 120, width: baseView.frame.width - 30, height: 40))
        phone_label.layer.cornerRadius = 5
        phone_label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        phone_label.layer.borderWidth = 2
        phone_label.placeholder = "Student Cell #"
        phone_label.textAlignment = .center
        phone_label.autocorrectionType = .no
        phone_label.delegate = self
        phone_label.keyboardType = UIKeyboardType.numberPad
        seqView.addSubview(phone_label)
        
        email_label = UITextField(frame: CGRect(x: baseView.frame.width + 15, y: 180, width: baseView.frame.width - 30, height: 40))
        email_label.layer.cornerRadius = 5
        email_label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        email_label.layer.borderWidth = 2
        email_label.placeholder = "School Email"
        email_label.textAlignment = .center
        email_label.autocorrectionType = .no
        email_label.autocapitalizationType = .none
        seqView.addSubview(email_label)

        confirmButton = UIButton(frame: CGRect(x: baseView.frame.width + 15, y: 240, width: baseView.frame.width - 30, height: 40))
        confirmButton.layer.cornerRadius = 5
        pay_label = UILabel(frame: CGRect(x: 0, y: 0, width: confirmButton.frame.width, height: confirmButton.frame.height))
        pay_label.text = "PAY"
        pay_label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pay_label.textAlignment = .center
        pay_label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        confirmButton.addSubview(pay_label)
        confirmButton.backgroundColor = #colorLiteral(red: 0.3744472843, green: 0.7592005076, blue: 0.3296852075, alpha: 1)
        confirmButton.addTarget(self, action: #selector(reviewPay), for: .touchUpInside)
        seqView.addSubview(confirmButton)
        
        keyboardAssist = UIButton(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 40))
        keyboardAssist.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        keyboardAssist.addTarget(self, action: #selector(closeKeys), for: .touchUpInside)
        keyboardAssist.addTarget(self, action: #selector(closeKeys), for: .touchDragExit)
        keyboardAssist.addTarget(self, action: #selector(closeKeys), for: .touchDragInside)
        var image = UIImageView(frame: CGRect(x: keyboardAssist.frame.width/2 - 15, y: 5, width: 30, height: 30))
        image.image = #imageLiteral(resourceName: "closeKayboard")
        image.contentMode = .scaleAspectFit
        keyboardAssist.addSubview(image)
        view.addSubview(keyboardAssist)
    }
    //closes any keyboard that might be open
    @objc func closeKeys(){
        name_label.resignFirstResponder()
        phone_label.resignFirstResponder()
        email_label.resignFirstResponder()
        paymentTextField.resignFirstResponder()
    }
    //reviews the payment and info for validity
    @objc func reviewPay(){
        errorView.removeFromSuperview()
        name_label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        phone_label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        email_label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        name_label.resignFirstResponder()
        phone_label.resignFirstResponder()
        email_label.resignFirstResponder()
        let name = name_label.text
        let phone = phone_label.text
        let email = email_label.text
        
        if !cardValid {
            showErrorMessage(str: "Invalid Card")
            seqView.scrollRectToVisible(CGRect(x: 0, y: 0, width: seqView.frame.width, height: seqView.frame.height), animated: true)
            return
        }
        
        if name?.count == 0 {
            showErrorMessage(str: "Please Enter Your Name.")
            name_label.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            return
        }else if !(name?.contains(" "))!{
            showErrorMessage(str: "Please Enter Your First and Last Name.")
            name_label.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            return
        }else{
            studentName = name!
        }
        
        if !(phone?.count == 13) {
            showErrorMessage(str: "Please enter a valid 10 digit phone number.")
            phone_label.text = ""
            phone_label.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            return
        }else{
            studentphoneNumber = phone!
        }
        
        if !(email?.contains("@"))!{
            showErrorMessage(str: "Please enter a valid email address")
            email_label.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            return
        }else{
            studentemail = email!
        }
        
        submitPayment()
    }
    //shows the error message if invalid info
    func showErrorMessage(str: String){
        errorView = UIView(frame: CGRect(x: baseView.frame.width + 15, y: 15, width: baseView.frame.width - 30, height: 30))
        var errorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        errorImage.image = #imageLiteral(resourceName: "error")
        errorImage.contentMode = .scaleAspectFit
        errorView.addSubview(errorImage)
        var errorText = UILabel(frame: CGRect(x: 40, y: 0, width: errorView.frame.width - 55, height: errorView.frame.height))
        errorText.text = str
        errorText.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        errorText.font = UIFont.boldSystemFont(ofSize: 12)
        errorView.addSubview(errorText)
        seqView.addSubview(errorView)
    }
    //changing phone number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 3 {
            textField.text = "("+textField.text!+")"
        }else if textField.text?.count == 8 {
            let str = textField.text
            let lowerBound = String.Index.init(encodedOffset: 0)
            let upperBound = String.Index.init(encodedOffset: 8)
            let beg = String(str![lowerBound..<upperBound])
            let end = String(str![upperBound...])
            textField.text = beg + "-" + end
        }else if textField.text?.count == 13 {
            if !deleting{
                textField.resignFirstResponder()
                deleting = true
            }else{
                textField.text = ""
                deleting = false
            }
        }
        return true
    }
    //page control
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: baseView.frame.width/2 - 150, y: baseView.frame.height - 50, width: 300, height: 50))
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        baseView.addSubview(pageControl)
    }
    
    func setPrice(to: Int){
        price = to
        price_label.text = "$"+String(price)
    }
    
    func addPayAsYouGo(){
        note_lab.text = "Your card will be charged $1 so that a valid payment method can be verified. Each time you drop off laundry or dry cleaning, this payment method will be used for billing."
    }
    
    func setPlanDetails(plan: String, semesters: String, cleaningCred: String , bedding: String){
        laundryPlan = plan
        if plan != "" && plan != "PAY AS YOU GO"{
            planDetails = semesters + " semester(s) of the " + plan + " plan with " + cleaningCred + " of Dry Cleaning Credit and " + bedding + " Clean Beddings per semester."
        }else if plan == "PAY AS YOU GO"{
            planDetails = "Pay As You Go plan."
        }else{
            planDetails = cleaningCred + " of dry cleaning credit."
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    //close the payment page
    @objc func closeAction(){
        view.removeFromSuperview()
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        card.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationYear, cvc: textField.cvc)
        if textField.valid {
            textField.borderColor = #colorLiteral(red: 0.3744472843, green: 0.7592005076, blue: 0.3296852075, alpha: 1)
            textField.resignFirstResponder()
            seqView.scrollRectToVisible(CGRect(x: seqView.frame.width, y: seqView.frame.minY ,width: seqView.frame.width, height: seqView.frame.height), animated: true)
            pageControl.currentPage = 1
            errorView.removeFromSuperview()
            cardValid = true
        }else{
            cardValid = false
        }
    }
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        card.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        card.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        card.paymentCardTextFieldDidEndEditingCVC()
        card.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func submitPayment() {
        
        let card = paymentTextField.cardParams
        STPAPIClient.shared().createToken(withCard: card, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                print(token)
                self.chargeUsingToken(token: token)
            }
        })
    }
    
    
    //var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.backendBaseURL, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func chargeUsingToken(token: STPToken){
        
        self.pay_label.removeFromSuperview()
        var activity = NVActivityIndicatorView(frame: CGRect(x: self.confirmButton.frame.width/2 - 15, y: 5, width: 30, height: 30))
        activity.type = NVActivityIndicatorType(rawValue: 5)!
        self.confirmButton.addSubview(activity)
        activity.startAnimating()
        
        var paymentDescription = "Payment type: Mobile" + "; Student name: " + studentName + "; Student phone number: " + studentphoneNumber + "; Student plan details: " + planDetails
        purchaseDescription = paymentDescription
        
        let params: [String: Any]  = ["stripeToken": token.tokenId, "amount": String(price), "currency": "usd", "description": paymentDescription, "email": studentemail]
        //let params = ["stripeToken": token.tokenId, "amount": "200", "currency": "usd", "description": "testRun"]


        let frame = CGRect(x: (self.view.frame.size.width/2.0)-37.5, y: 100.0, width: 75.0, height: 75.0)

        let url = self.baseURL/*.appendingPathComponent("charge")*/
//        Alamofire.request(url, parameters: params).validate(statusCode: 200..<300).responseJSON { response in
//            print(response.request!)
//            print(response.response!)
//            print(response.data!)
//            print(response.result)
//
//
//            if let codeStatus = response.response?.statusCode {
//                switch(codeStatus){
//                case 200:
//                    print("payment success")
//                default:
//                    print("error with response status: \(codeStatus)")
//                }
//            }
//
//            if let result = response.result.value  {
//                let JSON = result as! NSDictionary
//                print("JSON: \(JSON)")
//                //print(JSON.status)
//
//            }
//
//            let pymnt = Payments(context: self.managedObjectContext)
//            pymnt.cost = String(self.price)
//            pymnt.type = self.laundryPlan
//            pymnt.date = self.resultDate
//
//            if response.result.isSuccess {
//                //Show completion alert
//                print("success")
//            }
//            else {
//                //Show Failure alert
//               print("rejected")
//            }
//
//        }
        
        Alamofire.request(url , method: .post , parameters: params).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            
            if response.result.isSuccess {
                print("success")
                let pymnt = Payments(context: self.managedObjectContext)
                pymnt.cost = String(self.price)
                pymnt.type = self.laundryPlan
                pymnt.date = self.resultDate
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.closeViewController()
            }else{
                print("failure")
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.showErrorMessage(str: "Something went wrong! Try another card or retry.")
                self.confirmButton.addSubview(self.pay_label)
            }
        }
    }
    
    func closeViewController(){
        if laundryPlan != "PAY AS YOU GO" && laundryPlan != ""{
            let par = parent as! ReviewPurchase
            let par2 = par.parent as! LaundryPlans
            let par3 = par2.parent as! Home3
            self.view.removeFromSuperview()
            par.view.removeFromSuperview()
            par2.view.removeFromSuperview()
            par3.confirmPayment(description: purchaseDescription, email: studentemail)
        }else if laundryPlan == "PAY AS YOU GO"{
            let par = parent as! LaundryPlans
            let par2 = par.parent as! Home3
            self.view.removeFromSuperview()
            par.view.removeFromSuperview()
            par2.confirmPayment(description: purchaseDescription, email: studentemail)
        }else{
            let par = parent as! DryCleaning
            let par2 = par.parent as! LaundryPlans
            let par3 = par2.parent as! Home3
            self.view.removeFromSuperview()
            par.view.removeFromSuperview()
            par2.view.removeFromSuperview()
            par3.confirmPayment(description: purchaseDescription, email: studentemail)
        }
    }
}

