//
//  SubTemplateVC.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/19/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

class SubTemplateVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initBackButton()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func initBackButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 50, height: 50))
        let image = UIImageView(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
        image.image = #imageLiteral(resourceName: "exit")
        image.contentMode = .scaleAspectFit
        button.addSubview(image)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func initTitle(name : String){
        let label = UILabel(frame: CGRect(x: view.frame.width/2 - 150, y: 30, width: 300, height: 50))
        label.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir Next", size: 25)
        label.text = name
        view.addSubview(label)
    }
    
    @objc func back(){
        self.view.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
