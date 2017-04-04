//
//  DBProvider.swift
//  Uber For Rider
//
//  Created by Haider Rasool on 3/31/17.
//  Copyright © 2017 Haider Rasool. All rights reserved.
//
import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance : DBProvider = DBProvider();
    static var Instance : DBProvider {
        return _instance;
    }
    
    private var databaseRef : FIRDatabaseReference{
        return FIRDatabase.database().reference();
    }
    
    var riderRef : FIRDatabaseReference{
        return self.databaseRef.child(Constants.RIDERS);
    }
    
    var riderUberRequestRef : FIRDatabaseReference{
        return self.databaseRef.child(Constants.UBER_REQUEST);
    }
    var uberAcceptedRef : FIRDatabaseReference{
        return self.databaseRef.child(Constants.UBER_ACCEPTED);
    }
    
    
    public func SaveUser ( UID : String, Email : String, Password : String)
    {
        let data : Dictionary <String, Any> = [Constants.EMAIL : Email, Constants.PASSWORD : Password, Constants.ISRIDER : true]
        self.riderRef.child(UID).child(Constants.DATA).setValue(data);
        
    }
}
