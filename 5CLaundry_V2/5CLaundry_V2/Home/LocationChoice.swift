//
//  LocationChoice.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/18/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Firebase

class LocationChoice: UIViewController , MKMapViewDelegate {
    
    var mapView = UIView()
    var map = MKMapView()
    
    var managedObjectContext: NSManagedObjectContext!
    
    //    //Get registration Token
    var registrationToken : String?
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = UIView(frame: CGRect(x: view.frame.width/2 - 150, y: view.frame.height/2 - 150, width: 300, height: 300))
        mapView.layer.cornerRadius = 150
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        map.layer.cornerRadius = 20
        map.delegate = self
        mapView.addSubview(map)
        view.addSubview(mapView)
        
        var label = UILabel(frame: CGRect(x: view.frame.width/2 - 150, y: view.frame.height/2 - 190, width: 300, height: 20))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir Next Bold", size: 18)
        label.text = "Choose Your Pick-Up Location"
        view.addSubview(label)
        
        var skip = UIButton(frame: CGRect(x: view.frame.width/2 - 150, y: view.frame.height/2 + 170, width: 300, height: 30))
        skip.addTarget(self, action: #selector(self.skip), for: .touchUpInside)
        var buttonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        buttonLabel.text = "Skip"
        buttonLabel.textColor = UIColor.white
        buttonLabel.textAlignment = .center
        buttonLabel.font = UIFont(name: "Avenir Next Bold", size: 15)
        skip.addSubview(buttonLabel)
        view.addSubview(skip)
        

        // Do any additional setup after loading the view.
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        registrationToken = appDel.registrationToken
        
        
        mapView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.showAnimate()
        
        // Do any additional setup after loading the view.
        // set initial location in Claremont
        let initialLocation = CLLocation(latitude: 34.101478, longitude: -117.708104)
        centerMapOnLocation(location: initialLocation)
        
        // Drop a pin Pomona
        let dropPomonaPin = MKPointAnnotation()
        dropPomonaPin.coordinate = pomonaLocation
        dropPomonaPin.title = "Pomona"
        map.addAnnotation(dropPomonaPin)
        
        // Drop a pin CMC
        let dropCMCPomonaNorthPin = MKPointAnnotation()
        dropCMCPomonaNorthPin.coordinate = cmcPomonaNorthLocation
        dropCMCPomonaNorthPin.title = "CMC/Pomona North"
        map.addAnnotation(dropCMCPomonaNorthPin)
        
        // Drop a pin Mudd Scripps
        let dropMuddScrippsPin = MKPointAnnotation()
        dropMuddScrippsPin.coordinate = muddScrippsLocation
        dropMuddScrippsPin.title = "Mudd & Scripps"
        map.addAnnotation(dropMuddScrippsPin)
        
        // Drop a pin Pitzer
        let dropPitzerPin = MKPointAnnotation()
        dropPitzerPin.coordinate = pitzerLocation
        dropPitzerPin.title = "Pitzer"
        map.addAnnotation(dropPitzerPin)
        
        // Drop a pin CMC Towers
        let dropCMCTowersPin = MKPointAnnotation()
        dropCMCTowersPin.coordinate = cmcTowersLocation
        dropCMCTowersPin.title = "CMC Towers"
        map.addAnnotation(dropCMCTowersPin)
        
        // Drop a pin Scripps
        let dropScrippsPin = MKPointAnnotation()
        dropScrippsPin.coordinate = scrippsLocation
        dropScrippsPin.title = "Scripps"
        map.addAnnotation(dropScrippsPin)
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func skip(){
        let chosenSchool = Preference(context: self.managedObjectContext)
        chosenSchool.didComplete = true
        chosenSchool.schoolChosen = ""
        chosenSchool.date = Date()
        self.removeAnimate()
    }
    
    func handleNilRegistrationToken() -> String{
        return ""
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    
    let regionRadius: CLLocationDistance = 800
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
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
            storeNotificationLocation()
            self.removeAnimate()
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
            storeNotificationLocation()
            self.removeAnimate()
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
            storeNotificationLocation()
            self.removeAnimate()
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
            storeNotificationLocation()
            self.removeAnimate()
        }
        else if view.annotation?.coordinate.latitude == cmcTowersLocation.latitude &&
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
            storeNotificationLocation()
            self.removeAnimate()
        }
        else if view.annotation?.coordinate.latitude == scrippsLocation.latitude &&
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
            storeNotificationLocation()
            self.removeAnimate()
        }
    }
    
    func showAnimate(){
        //animation to show the pop up
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        //animation when removing pop up
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        })
    }
    
    func storeNotificationLocation() {
        //        var registrationToken = Messaging.messaging().fcmToken
        let ref = Database.database().reference().child("users")
        //ERROR THROWN IN HERE INSTALL APP, CHOOSE LOCATION.> CRASHES< BUT ON REPONEN EVERYTHING WORKS.
        //IF YOU SKIP FIRST Intro pop up, then everything seems to work fine. after delete and install. (but does fatal error nil on close but doesn't seem to affect) ?
        //after delete and install, choosing initial location throws fatal and crashes.
        ref.child("users")
            .child(registrationToken!)
            .setValue(["Notification Location": Preference(context: self.managedObjectContext).schoolChosen])
        
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

class PurchasePopUp: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let container = UIView(frame: CGRect(x: view.frame.width/2 - 150, y: view.frame.height/2 - 75, width: 300, height: 150))
        container.backgroundColor = UIColor(white: 0, alpha: 0.5)
        container.layer.cornerRadius = 15
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: 270, height: 100))
        label.text = "Would you like to purchase a laundry plan?"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        container.addSubview(label)
        let buttonN = UIButton(frame: CGRect(x: 15, y: 110, width: 120, height: 30))
        buttonN.backgroundColor = UIColor.clear
        let labelN = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        labelN.text = "No"
        labelN.textAlignment = .center
        labelN.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        labelN.font = UIFont(name: "Avenir Next", size: 25)
        let buttonY = UIButton(frame: CGRect(x: 150, y: 110, width: 120, height: 30))
        buttonY.backgroundColor = UIColor.clear
        let labelY = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        labelY.text = "Yes"
        labelY.textAlignment = .center
        labelY.textColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
        labelY.font = UIFont(name: "Avenir Next", size: 25)
        
        buttonN.addTarget(self, action: #selector(no), for: .touchUpInside)
        buttonY.addTarget(self, action: #selector(yes), for: .touchUpInside)
        
        buttonN.addSubview(labelN)
        container.addSubview(buttonN)
        
        buttonY.addSubview(labelY)
        container.addSubview(buttonY)
        
        view.addSubview(container)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func yes(){
        let par = parent as! Home3
        self.view.removeFromSuperview()
        par.transitionTo(cls: "LaundryPlans")
    }
    
    @objc func no(){
        let par = parent as! Home3
        par.setAfter()
        self.view.removeFromSuperview()
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
