//
//  RiderVC.swift
//  Uber For Rider
//
//  Created by Haider Rasool on 3/31/17.
//  Copyright © 2017 Haider Rasool. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController {
    @IBOutlet weak var map_rider: MKMapView!
    @IBOutlet weak var btn_rideraction: UIButton!
    
    var locationmanager = CLLocationManager();
    
    var userlocation : CLLocationCoordinate2D?;
    var driverlocation : CLLocationCoordinate2D?;
    var UberActive : Bool?;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UberHandler.Instance.delegate = self;
        UberHandler.Instance.StartListeningtoUberAcceptedRequests();
        
        locationmanager.delegate = self;
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.requestWhenInUseAuthorization();
        locationmanager.startUpdatingLocation();
        
        UberActive = false;
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationcoordinates = manager.location?.coordinate{
            self.userlocation = locationcoordinates;
            let region = MKCoordinateRegion(center: locationcoordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            map_rider.removeAnnotations(map_rider.annotations);
            map_rider.setRegion(region, animated: true);
            
            let annotation = MKPointAnnotation();
            annotation.title = "Rider";
            annotation.coordinate = self.userlocation!;
            map_rider.addAnnotation(annotation);
            
            if driverlocation != nil {
                if UberActive! {
                    let annotation1 = MKPointAnnotation();
                    annotation1.title = "Driver";
                    annotation1.coordinate = self.driverlocation!;
                    map_rider.addAnnotation(annotation1);
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logout(){
            dismiss(animated: true, completion: nil);
        }else{
            self.showAlert(msg: "Error Logging Out! Try again.", title: "LogoutError");
        }
    }
    func showAlert( msg:String, title: String)
    {
        let alertctrl = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        let okbtn = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alertctrl.addAction(okbtn);
        present(alertctrl, animated: true, completion: nil);
    }

    @IBAction func action_callUber(_ sender: Any) {
        if userlocation != nil{
            UberHandler.Instance.saveUberRequest(latitude: Double((userlocation?.latitude)!), longitude: Double((userlocation?.longitude)!));
        }
    }
    func UberAccepted(name: String, longitude: Double, latitude: Double) {
        self.btn_rideraction.setTitle("Cancel Uber", for: .normal);
        self.driverlocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        UberActive = true;
    }
    func UpdateDriver(longitude: Double, latitude: Double)
    {
        self.driverlocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
    }
}
