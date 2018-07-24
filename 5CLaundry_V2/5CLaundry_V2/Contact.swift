//
//  Contact.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/19/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class Contact: SubTemplateVC, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        super.initTitle(name: "Contact Us")
        // Do any additional setup after loading the view.
        
        var text_button = UIButton(frame: CGRect(x: 30, y: view.frame.height/2 - 25, width: view.frame.width - 60, height: 50))
        var text_label = UILabel(frame: CGRect(x: 0, y: 0, width: text_button.frame.width, height: text_button.frame.height))
        text_label.text = "Text Us"
        text_label.font = UIFont.boldSystemFont(ofSize: 20)
        text_label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        text_label.textAlignment = .center
        text_button.addSubview(text_label)
        text_button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        text_button.layer.cornerRadius = 15
        text_button.addTarget(self, action: #selector(sendText), for: .touchUpInside)
        self.view.addSubview(text_button)
        
        var call_button = UIButton(frame: CGRect(x: 30, y: text_button.frame.minY - 70, width: view.frame.width - 60, height: 50))
        var call_label = UILabel(frame: CGRect(x: 0, y: 0, width: call_button.frame.width, height: call_button.frame.height))
        call_label.text = "Call Us"
        call_label.font = UIFont.boldSystemFont(ofSize: 20)
        call_label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        call_label.textAlignment = .center
        call_button.addSubview(call_label)
        call_button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        call_button.layer.cornerRadius = 15
        call_button.addTarget(self, action: #selector(callNumber), for: .touchUpInside)
        self.view.addSubview(call_button)
        
        var email_button = UIButton(frame: CGRect(x: 30, y: text_button.frame.maxY + 20, width: view.frame.width - 60, height: 50))
        var email_label = UILabel(frame: CGRect(x: 0, y: 0, width: email_button.frame.width, height: email_button.frame.height))
        email_label.text = "Email Us"
        email_label.font = UIFont.boldSystemFont(ofSize: 20)
        email_label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        email_label.textAlignment = .center
        email_button.addSubview(email_label)
        email_button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        email_button.layer.cornerRadius = 15
        email_button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        self.view.addSubview(email_button)
        
        var find = UIButton(frame: CGRect(x: 30, y: view.frame.height - 100, width: view.frame.width - 60, height: 50))
        var find_label = UILabel(frame: CGRect(x: 0, y: 0, width: find.frame.width, height: find.frame.height))
        var looking = UILabel(frame: CGRect(x: 30, y: view.frame.height - 120, width: view.frame.width - 60, height: 20))
        looking.textAlignment = .center
        looking.font = UIFont.boldSystemFont(ofSize: 13)
        looking.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        looking.text = "Looking for the 5C Laundry van?"
        view.addSubview(looking)
        find_label.text = "Find the Van"
        find_label.font = UIFont.boldSystemFont(ofSize: 20)
        find_label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        find_label.textAlignment = .center
        find.addSubview(find_label)
        find.backgroundColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        find.layer.cornerRadius = 15
        find.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        find.layer.borderWidth = 2
        find.addTarget(self, action: #selector(findVan), for: .touchUpInside)
        self.view.addSubview(find)
    }
    
    @objc func findVan(){
        var par = parent as! Home3
        self.view.removeFromSuperview()
        par.transitionTo(cls: "Information")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    @objc func callNumber() {
        
        if let phoneCallURL = URL(string: "tel://6196639274") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func sendText() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            //Set phone number to current 5CLaundry manager
            controller.recipients = ["6196639274"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@5claundry.com"])
        mailComposerVC.setSubject("Question/Concern")
        mailComposerVC.setMessageBody("5C Laundry, ", isHTML: false)
        
        return mailComposerVC
    }
    
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Oops!", message:"This feature is not available right now. Please visit our website.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(alert, animated: true){}
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?){
        controller.dismiss(animated: true, completion: nil)
    }
}
