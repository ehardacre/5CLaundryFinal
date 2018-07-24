//
//  ViewController.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/18/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView
import Firebase

class Home: TemplateVC , UITableViewDataSource, UITableViewDelegate {
    
    var table : UITableView = UITableView()
    var items = ["My Account", "Laundry Plans", "Delivery Schedule", "Contact", "Information"]
    var images = [#imageLiteral(resourceName: "myAccount"), #imageLiteral(resourceName: "laundry"), #imageLiteral(resourceName: "schedule"), #imageLiteral(resourceName: "contact"), #imageLiteral(resourceName: "info")]
    
    //variable initialization
    var managedObjectContext: NSManagedObjectContext!
    var schoolChosen = [Preference]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTable()
        setUp()
    }
    
    func setUp(){
        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDel.persistentContainer.viewContext
        let request : NSFetchRequest<Preference> = Preference.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        do{
            schoolChosen = try managedObjectContext.fetch(request)
        }catch{
            print(error)
        }
        let complete = schoolChosen.count != 0
        //If user has not chosen a notification location we keep prompting them when opening the app.
        if !complete{
            self.buyPlanPopUp()
            self.showPopUpLoc()
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
    
    func initTable(){
        table = UITableView(frame: CGRect(x: 0,
                                          y: 110,
                                          width: view.frame.width,
                                          height: view.frame.height - (110)))
        table.dataSource = self
        table.delegate = self
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "menuItem")
        table.separatorStyle = .none
        view.addSubview(table)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItem")!
        cell.selectionStyle = .none
        cell.addSubview(cellImage(row: indexPath.row))
        cell.addSubview(cellLabel(row: indexPath.row))
        return cell
    }
    
    func cellImage(row : Int) -> UIView {
        let container = UIView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        container.layer.cornerRadius = 10
        container.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        let image = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        image.image = images[row]
        image.contentMode = .scaleAspectFit
        container.addSubview(image)
        return container
    }
    
    func cellLabel(row: Int) -> UIView {
        let label = UILabel(frame: CGRect(x: 110, y: 40, width: view.frame.width - 110, height: 40))
        label.text = items[row]
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transitionTo(cls: items[indexPath.row].replacingOccurrences(of: " ", with: ""))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

