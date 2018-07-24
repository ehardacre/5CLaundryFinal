//
//  MyAccount.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/19/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Firebase

/*
 CLASS: The Settings/MyAccount View Controller
 */
class MyAccount: SubTemplateVC, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    //variable to be toggled when editting map
    var mapOpen = false
    
    //Set Pomona location
    let pomonaLocation = CLLocationCoordinate2DMake(34.097080, -117.712696)
    //Set CMC location
    let cmcPomonaNorthLocation = CLLocationCoordinate2DMake(34.101380, -117.709346)
    //Set Mudd and Scripps Location
    let muddScrippsLocation = CLLocationCoordinate2DMake(34.105442, -117.710485)
    //Set Pitzer Location
    let pitzerLocation = CLLocationCoordinate2DMake(34.103932, -117.704441)
    //Set CMC Towers location
    let cmcTowersLocation = CLLocationCoordinate2DMake(34.099718, -117.707759)
    //set Scripps location
    let scrippsLocation = CLLocationCoordinate2DMake(34.104314, -117.708358)
    
    //Initialization of the annotations that will be placed on the map
    var annotations = [MKPointAnnotation]()
    let dropPomonaPin = MKPointAnnotation()
    let dropCMCPomonaNorthPin = MKPointAnnotation()
    let dropMuddScrippsPin = MKPointAnnotation()
    let dropPitzerPin = MKPointAnnotation()
    let dropScrippsPin = MKPointAnnotation()
    let dropCMCTowersPin = MKPointAnnotation()
    
    //Core Data variables
    var managedObjectContext: NSManagedObjectContext!
    var payments = [Payments]()
    var preference = [Preference]()
    var schoolChosen = ""
    
    //fire base registration token
    let registrationToken = Messaging.messaging().fcmToken
    
    //UI Variables
    var table = UITableView()
    var tableLabel = UILabel()
    var view_width = CGFloat(0)
    var map = MKMapView()
    var notificationSetLabel = UILabel()
    var editButton = EditButton()
    var editLabel = UILabel()
    
    
    //Operations to be performed after the view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize the header from TemplateVC
        super.initTitle(name: "Settings")
        
        //initialize the positions of the objects in myAccount
        initPositions()
        
        //Access Core Data for the most recent school chosen and the payments made by the user
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let prefRequest : NSFetchRequest<Preference> = Preference.fetchRequest()
        let payRequest : NSFetchRequest<Payments> = Payments.fetchRequest()
        do{
            preference = try managedObjectContext.fetch(prefRequest)
            payments = try managedObjectContext.fetch(payRequest)
        }catch{
            print(error)
        }
        let complete = preference.count != 0
        //var recent : Preference = Preference()
        var recent : Preference?
        if complete {
            recent = preference[preference.count - 1]
            
        }
        
        // set initial map location in Claremont
        let initialLocation = CLLocation(latitude: 34.101478, longitude: -117.708104)
        centerMapOnLocation(location: initialLocation)
        
        setCurrentStop()
        
        //Set notification label at load
        if recent?.schoolChosen == "" {
            notificationSetLabel.text = "You are not set to recieve notifications"
        } else {
            notificationSetLabel.text = "You are set to recieve notifications for: " + (recent?.schoolChosen)!
        }
        
        table.register(paymentCell.self, forCellReuseIdentifier: "payment")
        view_width = CGFloat(table.frame.width)
        
        if payments.count == 0{
            shutDownTable()
        }
    }
    
    /*
     FUNCTION: Initializes the positions of the UI Elements
     */
    func initPositions(){
        
        //Map initialization
        map = MKMapView(frame: CGRect(x: 30, y: 100, width: view.frame.width - 60, height: 300))
        map.layer.cornerRadius = 20
        map.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        map.layer.borderWidth = 1
        map.delegate = self
        
        //Edit Button ititialization
        editLabel = UILabel(frame: CGRect(x: 7, y: map.frame.height - 50, width: map.frame.width - 14, height: 43))
        editLabel.layer.cornerRadius = editLabel.frame.height/2
        editLabel.clipsToBounds = true
        editLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        editLabel.text = "Edit Push Notifications"
        editLabel.textAlignment = .center
        editLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        editButton = EditButton(frame: CGRect(x: map.frame.width - 50, y: map.frame.height - 50, width: 43, height: 43))
        editButton.addTarget(self, action: #selector(editMap(_:)), for: .touchUpInside)
        map.addSubview(editLabel)
        map.addSubview(editButton)
        view.addSubview(map)
        
        
        //The label that notifies the user of where they are set to recieve notifications
        notificationSetLabel = UILabel(frame: CGRect(x: 30, y: 405, width: view.frame.width - 60, height: 20))
        notificationSetLabel.textAlignment = .center
        notificationSetLabel.font = UIFont(name: "Avenir Next", size: 12)
        notificationSetLabel.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        view.addSubview(notificationSetLabel)
        
        //the label that informs the user of the purpose of the tableView
        tableLabel = UILabel(frame: CGRect(x: 30, y: 450, width: view.frame.width - 60, height: 20))
        tableLabel.text = "Purchased Plans"
        tableLabel.textAlignment = .center
        tableLabel.font = UIFont(name: "Avenir Next", size: 20)
        tableLabel.textColor = #colorLiteral(red: 0.9876359105, green: 0.03355305269, blue: 0.03757116571, alpha: 1)
        view.addSubview(tableLabel)
        
        //purchase plan table view initialization
        table = UITableView(frame: CGRect(x: 30, y: 480, width: view.frame.width - 60, height: 150))
        table.separatorStyle = .none
        table.layer.cornerRadius = 15
        table.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        table.layer.borderWidth = 1
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
    }
    
    /*
     FUNCTIONS: TableView required functions
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of payments the user has mades
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set the reusable cell to type payment cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment") as! paymentCell
        //initialize cell properties with attributes from core data
        cell.initCell(plan_text: payments[indexPath.row].type!
            ,cost_text: "$" + payments[indexPath.row].cost!
            ,date_text: payments[indexPath.row].date!
        , cell_width: view_width)
        return cell
    }

    /*
     FUNCTION: Runs when there are no payments made by the user
 */
    func shutDownTable(){
        //A label that notifies the user that they have not made any previous purchases
        let noResults = UILabel(frame: table.frame)
        noResults.layer.cornerRadius = 15
        noResults.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        noResults.layer.borderWidth = 1
        noResults.text = "No Results"
        noResults.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        noResults.textAlignment = .center
        table.removeFromSuperview()
        view.addSubview(noResults)
    }
    
    /*
     FUNCTION: Target for editButton
    */
    @objc func editMap(_ sender: Any) {
        //changes boolean of mapOpen
        mapOpen = true
        
        //change appearance of edit button to indicate change state to the user
        editButton.bgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        editButton.lineColor = #colorLiteral(red: 0.9876359105, green: 0.03355305269, blue: 0.03757116571, alpha: 1)
        editButton.setNeedsDisplay()
        
        UIView.animate(withDuration: 0.25) {
            self.editLabel.frame = self.editButton.frame
        }
        
        //remove any current annotations on the map
        map.removeAnnotations(annotations)
        annotations.removeAll()
        
        //ReInstate all annnotations
        dropPomonaPin.coordinate = pomonaLocation
        dropPomonaPin.title = "Pomona"
        map.addAnnotation(dropPomonaPin)
        annotations.append(dropPomonaPin)
        dropCMCPomonaNorthPin.coordinate = cmcPomonaNorthLocation
        dropCMCPomonaNorthPin.title = "CMC/Pomona North"
        map.addAnnotation(dropCMCPomonaNorthPin)
        annotations.append(dropCMCPomonaNorthPin)
        dropMuddScrippsPin.coordinate = muddScrippsLocation
        dropMuddScrippsPin.title = "Mudd & Scripps"
        map.addAnnotation(dropMuddScrippsPin)
        annotations.append(dropMuddScrippsPin)
        dropPitzerPin.coordinate = pitzerLocation
        dropPitzerPin.title = "Pitzer"
        map.addAnnotation(dropPitzerPin)
        annotations.append(dropPitzerPin)
        dropScrippsPin.coordinate = scrippsLocation
        dropScrippsPin.title = "Scripps"
        map.addAnnotation(dropScrippsPin)
        annotations.append(dropScrippsPin)
        dropCMCTowersPin.coordinate = cmcTowersLocation
        dropCMCTowersPin.title = "CMC Towers"
        map.addAnnotation(dropCMCTowersPin)
        annotations.append(dropCMCTowersPin)
        
    }
    
    /*
     FUNCTION: mapView required function
     UPDATE: SWITCH statement instead of ifelse, without redundant statements in clauses
 */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Set the views for each of the annotations
        if annotation.coordinate.latitude == pitzerLocation.latitude &&
            annotation.coordinate.longitude == pitzerLocation.longitude{
            let view = shirtAnnotation()
            view.color = #colorLiteral(red: 1, green: 0.5304574429, blue: 0, alpha: 1)
            view.setImage()
            return view
        }else if annotation.coordinate.latitude == pomonaLocation.latitude &&
            annotation.coordinate.longitude == pomonaLocation.longitude{
            let view = shirtAnnotation()
            view.color = #colorLiteral(red: 0.1738977913, green: 0.2690466836, blue: 0.4895899429, alpha: 1)
            view.setImage()
            return view
        }else if annotation.coordinate.latitude == muddScrippsLocation.latitude &&
            annotation.coordinate.longitude == muddScrippsLocation.longitude{
            let view = shirtAnnotation()
            view.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            view.setImage()
            return view
        }else if annotation.coordinate.latitude == cmcPomonaNorthLocation.latitude &&
            annotation.coordinate.longitude == cmcPomonaNorthLocation.longitude{
            let view = shirtAnnotation()
            view.color = #colorLiteral(red: 0.9114054569, green: 0.03411303382, blue: 0, alpha: 1)
            view.setImage()
            return view
        }else if annotation.coordinate.latitude == cmcTowersLocation.latitude &&
            annotation.coordinate.longitude == cmcTowersLocation.longitude{
            let view = shirtAnnotation()
            view.color = #colorLiteral(red: 0.4496153236, green: 0.09087074131, blue: 0.2702187073, alpha: 1)
            view.setImage()
            return view
        }else if annotation.coordinate.latitude == scrippsLocation.latitude &&
            annotation.coordinate.longitude == scrippsLocation.longitude{
            let view = shirtAnnotation()
            view.color = #colorLiteral(red: 0.1959606201, green: 0.4773358185, blue: 0.2817423564, alpha: 1)
            view.setImage()
            return view
        }else{
            return MKAnnotationView()
        }
        
    }
    
    //set radius of the map
    let regionRadius: CLLocationDistance = 700
    /*
     FUNCTION: Centers the map on the location var
    */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    /*
     FUNCTION: Map view required function, called when user selects an annotaion
     UPDATE: SWITCH statement instead of ifelse without redundant statements in clauses
    */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //if the map is open then selecting causes action
        if mapOpen {
            //if the coordinates of the annotation match update the Preferences Core Data table
            if view.annotation?.coordinate.latitude == pitzerLocation.latitude &&
                view.annotation?.coordinate.longitude == pitzerLocation.longitude{
                let chosenSchool = Preference(context: self.managedObjectContext)
                chosenSchool.didComplete = true
                chosenSchool.schoolChosen = "Pitzer"
                chosenSchool.date = Date()
                do{
                    try managedObjectContext.save()
                } catch {
                    print("error saving managedOjectContext: \(error)")
                }
            }else if view.annotation?.coordinate.latitude == pomonaLocation.latitude &&
                view.annotation?.coordinate.longitude == pomonaLocation.longitude{
                let chosenSchool = Preference(context: self.managedObjectContext)
                chosenSchool.didComplete = true
                chosenSchool.schoolChosen = "Pomona"
                chosenSchool.date = Date()
                do{
                    try managedObjectContext.save()
                } catch {
                    print("error saving managedOjectContext: \(error)")
                }
            }else if view.annotation?.coordinate.latitude == muddScrippsLocation.latitude &&
                view.annotation?.coordinate.longitude == muddScrippsLocation.longitude{
                let chosenSchool = Preference(context: self.managedObjectContext)
                chosenSchool.didComplete = true
                chosenSchool.schoolChosen = "Mudd/Scripps"
                chosenSchool.date = Date()
                do{
                    try managedObjectContext.save()
                } catch {
                    print("error saving managedOjectContext: \(error)")
                }
            }else if view.annotation?.coordinate.latitude == cmcPomonaNorthLocation.latitude &&
                view.annotation?.coordinate.longitude == cmcPomonaNorthLocation.longitude{
                let chosenSchool = Preference(context: self.managedObjectContext)
                chosenSchool.didComplete = true
                chosenSchool.schoolChosen = "CMC/Pomona North"
                chosenSchool.date = Date()
                do{
                    try managedObjectContext.save()
                } catch {
                    print("error saving managedOjectContext: \(error)")
                }
            }else if view.annotation?.coordinate.latitude == cmcTowersLocation.latitude &&
                view.annotation?.coordinate.longitude == cmcTowersLocation.longitude{
                let chosenSchool = Preference(context: self.managedObjectContext)
                chosenSchool.didComplete = true
                chosenSchool.schoolChosen = "CMC Towers"
                chosenSchool.date = Date()
                do{
                    try managedObjectContext.save()
                } catch {
                    print("error saving managedOjectContext: \(error)")
                }
            }else if view.annotation?.coordinate.latitude == scrippsLocation.latitude &&
                view.annotation?.coordinate.longitude == scrippsLocation.longitude{
                let chosenSchool = Preference(context: self.managedObjectContext)
                chosenSchool.didComplete = true
                chosenSchool.schoolChosen = "Scripps"
                chosenSchool.date = Date()
                do{
                    try managedObjectContext.save()
                } catch {
                    print("error saving managedOjectContext: \(error)")
                }
            }
            
            //Change map to the new stop
            setCurrentStop()
            
        }
    }
    
    //the most recent preferences of the user
    var recent: Preference?
    
    /*
     FUNCTION: update to reflect new/current stop
     UPDATE: notify home view of changes to the current stop
             Switch statement with variables instead of ifelse with redundant calls
    */
    func setCurrentStop(){
        //remove all current annotations on map
        map.removeAnnotations(annotations)
        annotations.removeAll()
        
        //access the core data information
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let prefRequest : NSFetchRequest<Preference> = Preference.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        prefRequest.sortDescriptors = [sort]
        do{
            preference = try managedObjectContext.fetch(prefRequest)
        }catch{
            print(error)
        }
        
        let complete = preference.count != 0
        if complete {
            recent = preference[preference.count - 1]
            
        }
        
        //Update the map the reflect the chosen school
        if recent?.schoolChosen == "Pomona" || recent?.schoolChosen == ""{
            // Drop a pin
            dropPomonaPin.coordinate = pomonaLocation
            dropPomonaPin.title = "Pomona"
            map.addAnnotation(dropPomonaPin)
            annotations.append(dropPomonaPin)
            storeNotificationLocation()
        }
        
        if recent?.schoolChosen == "CMC/Pomona North" || recent?.schoolChosen == ""{
            // Drop a pin
            dropCMCPomonaNorthPin.coordinate = cmcPomonaNorthLocation
            dropCMCPomonaNorthPin.title = "CMC/Pomona North"
            map.addAnnotation(dropCMCPomonaNorthPin)
            annotations.append(dropCMCPomonaNorthPin)
            storeNotificationLocation()
        }
        
        if recent?.schoolChosen == "Mudd/Scripps" || recent?.schoolChosen == ""{
            // Drop a pin
            dropMuddScrippsPin.coordinate = muddScrippsLocation
            dropMuddScrippsPin.title = "Mudd & Scripps"
            map.addAnnotation(dropMuddScrippsPin)
            annotations.append(dropMuddScrippsPin)
            storeNotificationLocation()
        }
        
        if recent?.schoolChosen == "Pitzer" || recent?.schoolChosen == ""{
            // Drop a pin
            dropPitzerPin.coordinate = pitzerLocation
            dropPitzerPin.title = "Pitzer"
            map.addAnnotation(dropPitzerPin)
            annotations.append(dropPitzerPin)
            storeNotificationLocation()
        }
        
        if recent?.schoolChosen == "Scripps" || recent?.schoolChosen == ""{
            // Drop a pin
            dropScrippsPin.coordinate = scrippsLocation
            dropScrippsPin.title = "Scripps"
            map.addAnnotation(dropScrippsPin)
            annotations.append(dropScrippsPin)
            storeNotificationLocation()
        }
        
        if recent?.schoolChosen == "CMC Towers" || recent?.schoolChosen == ""{
            // Drop a pin
            dropCMCTowersPin.coordinate = cmcTowersLocation
            dropCMCTowersPin.title = "CMC Towers"
            map.addAnnotation(dropCMCTowersPin)
            annotations.append(dropCMCTowersPin)
            storeNotificationLocation()
        }
        
        //close map
        mapOpen = false
        //and update button look
        editButton.bgColor = #colorLiteral(red: 0.9876359105, green: 0.03355305269, blue: 0.03757116571, alpha: 1)
        editButton.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        editButton.setNeedsDisplay()
        
        UIView.animate(withDuration: 0.25) {
            self.editLabel.frame = CGRect(x: 7, y: self.map.frame.height - 50, width: self.map.frame.width - 14, height: 43)
        }
        editLabel.text = "Edit Push Notifications"
        
        //Set notification label at change in VC
        if recent?.schoolChosen == "" {
            notificationSetLabel.text = "You are not set to recieve notifications"
        } else {
            notificationSetLabel.text = "You are set to recieve notifications for: " + (recent?.schoolChosen)!
        }
    }
    
    
    /*
     FUNCTION: Store the location that the user has chosen in firebase so that the cron jobs will push to them
    */
    func storeNotificationLocation() {
        let ref = Database.database().reference().child("users")
        ref.child("users").child(registrationToken!).setValue(["Notification Location": recent?.schoolChosen])
    }

    /*
     FUNCTION: View Controller Required function
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/*
 CLASS: The class for the edit Button to allow a redraw
 */
@IBDesignable class EditButton: UIButton {
    
    //Color values of editButton
    var bgColor = #colorLiteral(red: 0.9876359105, green: 0.03355305269, blue: 0.03757116571, alpha: 1)
    var lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    /*
     FUNCTION: override the draw function for custom look
    */
    override func draw(_ rect: CGRect) {
        //initialize button base
        let button =  UIBezierPath(ovalIn: rect)
        bgColor.setFill()
        button.fill()
        
        //begin the path for the edit illustration
        let edit = UIBezierPath()
        lineColor.setStroke()
        let center = CGPoint(x: rect.width/2 , y: rect.height/2)
        edit.move(to: center)
        edit.addLine(to: CGPoint(x: center.x + 3, y: center.y))
        edit.addLine(to: CGPoint(x: center.x, y: center.y - 3))
        edit.close()
        
        edit.move(to: CGPoint(x: center.x, y: center.y - 3))
        edit.addLine(to: CGPoint(x: center.x + 10, y: center.y - 13))
        edit.addLine(to: CGPoint(x: center.x + 13, y: center.y - 10))
        edit.addLine(to: CGPoint(x: center.x + 3, y: center.y))
        
        edit.move(to: center)
        edit.addLine(to: CGPoint(x: center.x - 8, y: center.y))
        
        edit.move(to: CGPoint(x: center.x - 10, y: center.y))
        edit.addLine(to: CGPoint(x: center.x - 10, y: center.y - 7))
        edit.addLine(to: CGPoint(x: center.x + 5, y: center.y - 7))
        
        edit.move(to: CGPoint(x: center.x - 10, y: center.y))
        edit.addLine(to: CGPoint(x: center.x - 10, y: center.y + 7))
        edit.addLine(to: CGPoint(x: center.x + 7, y: center.y + 7))
        edit.addLine(to: CGPoint(x: center.x + 7 , y: center.y - 5))
        
        edit.stroke()
    }
    
}

/*
 CLASS: cell in the payment table used to display: Laundry Plan, Cost and Date
 */
class paymentCell : UITableViewCell {
    
    //initialize Views
    var plan = UILabel()
    var cost = UILabel()
    var date = UILabel()
    
    /*
     FUNCTION: required tableViewCell function
     */
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    /*
     FUNCTION: custom initializer function (called after the fact)
    */
    func initCell(plan_text: String, cost_text: String, date_text: String, cell_width : CGFloat){
        
            //remove all views from superview to prevent duplication when reused
            plan.removeFromSuperview()
            cost.removeFromSuperview()
            date.removeFromSuperview()
        
            //no need to select these tableView cells
            self.selectionStyle = .none
        
            //Initialize the plan label
            plan = UILabel(frame: CGRect(x: 15, y: 10, width: cell_width/2, height: 20))
            plan.textColor = UIColor.black
            plan.text = plan_text
        
            //Initialize the cost label
            cost = UILabel(frame: CGRect(x: cell_width/2, y: 10, width: cell_width/4, height: 20))
            cost.textColor = UIColor.black
            cost.text = cost_text
        
            //Initialize the date label
            date = UILabel(frame: CGRect(x: 3 * (cell_width/4), y: 10, width: cell_width/4, height:     20))
            date.textColor = UIColor.black
            date.text = date_text
        
            //add all subviews to the cell
            self.addSubview(plan)
            self.addSubview(cost)
            self.addSubview(date)
    }
    
}
