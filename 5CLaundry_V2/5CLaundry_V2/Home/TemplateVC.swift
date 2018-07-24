//
//  TemplateVC.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/18/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

class TemplateVC: UIViewController {
    
    var header : UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initHeader()
    }
    
    func initHeader(){
        header = UIImageView(frame: CGRect(x: 25, y: 30, width: view.frame.width - 50, height: 80))
        header.image = #imageLiteral(resourceName: "Banner")
        header.contentMode = .scaleAspectFit
        view.addSubview(header);
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
