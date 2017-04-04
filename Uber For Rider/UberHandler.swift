//
//  UberHandler.swift
//  Uber For Rider
//
//  Created by Haider Rasool on 4/1/17.
//  Copyright © 2017 Haider Rasool. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController : class{
    func UberAccepted(name:String, longitude:Double, latitude:Double);
    func UpdateDriver(longitude: Double, latitude: Double);
}

class UberHandler{
    private static let _instance = UberHandler();
    
    public static var Instance : UberHandler{
        return _instance;
    }
    weak var delegate : UberController?;
    
    var rider_email : String?;
    var driver_email : String?;
    var myUberRequestKey : String?;
    var UberAcceptedHandler : UInt?;
    
    public func StartListeningtoUberAcceptedRequests()
    {
        UberAcceptedHandler = DBProvider.Instance.uberAcceptedRef.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            if self.myUberRequestKey != nil{
                if snapshot.key == self.myUberRequestKey!{
                    if let data = snapshot.value as? Dictionary< String, Any >{
                        if let lat = data[Constants.LATITUDE] as? Double{
                            if let lon = data[Constants.LONGITUDE] as? Double{
                                if let name = data[Constants.NAME] as? String{
                                    self.delegate?.UberAccepted(name: name, longitude: lon, latitude: lat)
                                }
                            }
                        }
                    }
                }
            }
        });
        DBProvider.Instance.uberAcceptedRef.observe(.childChanged, with: { (snapshot) in
            if self.myUberRequestKey != nil{
                if snapshot.key == self.myUberRequestKey!{
                    if let data = snapshot.value as? Dictionary< String, Any >{
                        if let lat = data[Constants.LATITUDE] as? Double{
                            if let lon = data[Constants.LONGITUDE] as? Double{
                                self.delegate?.UpdateDriver(longitude: lon, latitude: lat);
                            }
                        }
                    }
                }
            }
        })
    }
    //public func StopListeningtoUberAcceptedRequests()
    //{
    //    DBProvider.Instance.uberAcceptedRef.removeObserver(withHandle: self.UberAcceptedHandler!);
    //}
    
    public func saveUberRequest (latitude : Double, longitude : Double)
    {
        let data: Dictionary< String, Any> = [Constants.NAME:rider_email!, Constants.LATITUDE: latitude, Constants.LONGITUDE:longitude];
        let ref = DBProvider.Instance.riderUberRequestRef.childByAutoId();
        myUberRequestKey = ref.key;
        ref.setValue(data);
    }
    
}
