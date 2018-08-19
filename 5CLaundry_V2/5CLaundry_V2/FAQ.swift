//
//  FAQ.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/19/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Firebase

class Information: SubTemplateVC , UIScrollViewDelegate, MKMapViewDelegate{
    
    var images = [#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (3)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (4)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (2)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (5)"),#imageLiteral(resourceName: "icons8-t-shirt-filled-50 (1)")]
    var notes = ["""
                     Parked in front of Atherton Hall
                     At the loading zone at the bottom of the stairs
                """,
                 """
                     Parked north of pool by volleyball courts
                """,
                 """
                     Parked in front of Towers
                """,
                 """
                     Parked behind Storyhouse (next to Collins)
                """,
                 """
                     Parked on Platt south of Mudd dining hall
                """,
                 """
                     Parked between Sumner Hall and Oldenborg Hall
                """
    ]

    var map = MKMapView()
    
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
    
    let dropPomonaPin = MKPointAnnotation()
    let dropCMCPomonaNorthPin = MKPointAnnotation()
    let dropMuddScrippsPin = MKPointAnnotation()
    let dropPitzerPin = MKPointAnnotation()
    let dropScrippsPin = MKPointAnnotation()
    let dropCMCTowersPin = MKPointAnnotation()
    
    var moreInfo_required = false
    
    var qaSize = CGFloat(250)

    var scrollView = UIScrollView()
    var questions = [ "Where can I find the 5CLaundry van?", "What is 5C Laundry?",
    "How soon will my laundry and dry cleaning be ready for pick-up?",
    "I want to use your dry-cleaning service, but I didn’t sign up for a semester-long plan. Can I still do so?",
    "I purchased too much dry cleaning credit, will my credits roll over to next semester?",
    "After the laundry is folded, how do you keep it from wrinkling? ",
    "My clothing requires special care. Will you ensure it is not damaged? ",
    "I would like service, but cannot make it to the truck location at the regular time. Can I still get service? ",
    "I missed the laundry truck. What do I do? ",
    "What happens if my clothing is damaged? "
    ]
    
    var answers = ["", "5C Laundry picks up dirty laundry and dry cleaning from various locations across the Claremont Colleges campus, brings it for professional cleaning, then delivers the clean laundry to campus.",
                   "Your laundry/dry cleaning will be done within 48 hours. This semester students can pickup/drop off MWF, but Friday dry cleaning drops will not be ready until Wednesday (laundry will be ready Monday). You can pick your laundry up at any truck location on campus.",
                   "Yes, dry cleaning service is available to everyone on campus. We encourage you purchase dry cleaning credits before the semester so you have a registered laundry bag.",
                   "Yes, dry cleaning credit will roll over from semester-to-semester and year-to-year. Credits cannot be redeemed for cash or be given to other students… so make sure you use them by graduation. If you run out of dry-cleaning credit and do not need to purchase $50+ more then we can charge you per-item on a weekly basis.",
                   "Laundry is folded after drying then wrapped to keep clothing wrinkle free and protected.",
                   "Yes, our cleaning partners have years of experience dealing with a variety of materials. If you have any delicates, they should be placed in your dry cleaning bag for special care.",
                   "Yes, please send an email to 5C Laundry to make arrangements for an alternative delivery times. If several students have request similar times then a new pickup/drop off can be added to the delivery schedule.",
                   "College is busy and we understand that you may be late/early for pickup. If you have missed us, take a look at the schedule to see where are on campus. We will try to arrive at each location a minute or two early and leave a minute or two late.",
                   "We have not had any issues with damage or lost items, but we are prepared to help. If you happen to put an delicate shirt in a laundry bag (instead of your dry cleaning bag) we will have that item dry cleaned (not laundered) and 5C Laundry will charge the student per item. In the event that an item is damaged/lost, we reimburse the student with the book value of that item. If this becomes an repeated issue, 5C Laundry reserves the right to terminate service and provide a prorated refund for unused service."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.initTitle(name: "FAQ")
        // Do any additional setup after loading the view.
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.delegate = self
        var housingView = UIView(frame: CGRect(x: 0, y: 75, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(housingView)
        let topShadow = EdgeShadowLayer(forView: housingView, edge: .Top)
        housingView.layer.addSublayer(topShadow)
        housingView.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(setViews(moreInfo: moreInfo_required) + 100))
        
        let initialLocation = CLLocation(latitude: 34.101478, longitude: -117.708104)
        centerMapOnLocation(location: initialLocation)
        
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
    
    func setViews(moreInfo: Bool) -> Int{
        var placement = 15
        for index in 0..<questions.count{
            
            
            var framingView = UIView(frame: CGRect(x: 15, y: CGFloat(placement), width: scrollView.frame.width - 30, height: qaSize - 50))
            framingView.layer.cornerRadius = 15
            framingView.layer.borderWidth = 3
            framingView.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
            scrollView.addSubview(framingView)
            
            var question = UILabel(frame: CGRect(x: 15, y: 15, width: framingView.frame.width - 30, height: qaSize/2))
            question.text = questions[index]
            question.font = UIFont.boldSystemFont(ofSize: 14)
            question.numberOfLines = 0
            question.sizeToFit()
            question.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            framingView.addSubview(question)
            
            if answers[index] == ""{
                
                map = MKMapView(frame: CGRect(x: 15, y: question.frame.height + 30, width: framingView.frame.width - 30, height: framingView.frame.width - 80))
                map.isScrollEnabled = false
                
                dropPomonaPin.coordinate = pomonaLocation
                dropPomonaPin.title = "Pomona"
                map.addAnnotation(dropPomonaPin)
                
                dropCMCPomonaNorthPin.coordinate = cmcPomonaNorthLocation
                dropCMCPomonaNorthPin.title = "CMC/Pomona North"
                map.addAnnotation(dropCMCPomonaNorthPin)
                
                dropMuddScrippsPin.coordinate = muddScrippsLocation
                dropMuddScrippsPin.title = "Mudd & Scripps"
                map.addAnnotation(dropMuddScrippsPin)
                
                dropPitzerPin.coordinate = pitzerLocation
                dropPitzerPin.title = "Pitzer"
                map.addAnnotation(dropPitzerPin)
                
                dropScrippsPin.coordinate = scrippsLocation
                dropScrippsPin.title = "Scripps"
                map.addAnnotation(dropScrippsPin)
                
                dropCMCTowersPin.coordinate = cmcTowersLocation
                dropCMCTowersPin.title = "CMC Towers"
                map.addAnnotation(dropCMCTowersPin)
                
                if !moreInfo_required {
                
                    framingView.frame = CGRect(x: framingView.frame.minX, y: framingView.frame.minY, width: framingView.frame.width, height: map.frame.height + question.frame.height + 60)
                    framingView.addSubview(map)
                    placement += Int(framingView.frame.height) + 15
                    map.delegate = self
                
                    var moreInfo_button = UIButton(frame: CGRect(x: framingView.frame.width/2 - 50, y: framingView.frame.height - 45, width: 100, height: 30))
                    var moreInfo_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    moreInfo_button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
                    moreInfo_button.layer.cornerRadius = 10
                    moreInfo_label.text = "More Info"
                    moreInfo_label.textAlignment = .center
                    moreInfo_label.textColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
                    moreInfo_label.font = UIFont.boldSystemFont(ofSize: 14)
                    moreInfo_button.addSubview(moreInfo_label)
                    moreInfo_button.addTarget(self, action: #selector(toggleInfo), for: .touchUpInside)
                    framingView.addSubview(moreInfo_button)
                    
                }else{
                    
                    var vanHints = UIView(frame: CGRect(x: 15, y: map.frame.height + 50, width: framingView.frame.width - 30, height: 300))
                    framingView.addSubview(vanHints)
                    
                    for j in 0..<images.count{
                        var imageContainer = UIView(frame: CGRect(x: 0, y: (j*50) + 10, width: 40, height: 40))
                        imageContainer.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                        imageContainer.layer.cornerRadius = 10
                        imageContainer.layer.borderWidth = 1
                        var image = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
                        image.image = images[j]
                        imageContainer.addSubview(image)
                        vanHints.addSubview(imageContainer)
                        
                        var location = UILabel(frame: CGRect(x: 45, y: (j*50) + 10, width: Int(framingView.frame.width - 50), height: 40))
                        location.text = notes[j]
                        location.font = UIFont.systemFont(ofSize: 11)
                        location.numberOfLines = 0
                        vanHints.addSubview(location)
                    }
                    
                    framingView.frame = CGRect(x: framingView.frame.minX, y: framingView.frame.minY, width: framingView.frame.width, height: map.frame.height + question.frame.height + vanHints.frame.height + 100)
                    framingView.addSubview(map)
                    placement += Int(framingView.frame.height) + 15
                    map.delegate = self
                    
                    var moreInfo_button = UIButton(frame: CGRect(x: framingView.frame.width/2 - 50, y: framingView.frame.height - 45, width: 100, height: 30))
                    var moreInfo_label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    moreInfo_button.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.03529411765, blue: 0.03546316964, alpha: 1)
                    moreInfo_button.layer.cornerRadius = 10
                    moreInfo_label.text = "Less Info"
                    moreInfo_label.textAlignment = .center
                    moreInfo_label.textColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
                    moreInfo_label.font = UIFont.boldSystemFont(ofSize: 14)
                    moreInfo_button.addSubview(moreInfo_label)
                    moreInfo_button.addTarget(self, action: #selector(toggleInfo), for: .touchUpInside)
                    framingView.addSubview(moreInfo_button)
                }
                
            }else{
                var answer = UILabel(frame: CGRect(x: 15, y: question.frame.height + 30, width:     framingView.frame.width - 30, height: qaSize/2))
                answer.text = answers[index]
                answer.font = UIFont.systemFont(ofSize: 14)
                answer.numberOfLines = 0
                answer.sizeToFit()
                answer.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                framingView.addSubview(answer)
                
                framingView.frame = CGRect(x: framingView.frame.minX, y: framingView.frame.minY, width:     framingView.frame.width, height: question.frame.height + answer.frame.height + 60)
                placement += Int(framingView.frame.height) + 15
            }
            
        }
        
        return placement
        
    }
    
    @objc func toggleInfo(){
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        moreInfo_required = !moreInfo_required
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(setViews(moreInfo: moreInfo_required) + 100))
        let initialLocation = CLLocation(latitude: 34.101478, longitude: -117.708104)
        centerMapOnLocation(location: initialLocation)
    }
    
    
    let regionRadius: CLLocationDistance = 600
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
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
