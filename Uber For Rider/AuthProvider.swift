//
//  AuthProvider.swift
//  Uber For Rider
//
//  Created by Haider Rasool on 3/31/17.
//  Copyright © 2017 Haider Rasool. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias ErrorHandler = (_ errormsg : String?) -> Void;

class AuthProvider{
    //singleton
    private static var _instance = AuthProvider();
    public static var Instance : AuthProvider{
        return _instance;
    }
    
    //error msgs
    struct ErrorMesseges {
        static let invalidPassword = "Invalid Password! Please provide a valid account password.";
        static let invalidUser = "Invalid Account! The provided account name does not exist in our system.";
        static let unknownError = "Unknown error occurred! Please try again.";
    }
    
    //Login
    public func login( email: String, pass: String, handler: ErrorHandler?)
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
            if(error != nil)
            {
                self.HandleErrors(error: error as! NSError, handler: handler);
            }else
            {
                UberHandler.Instance.rider_email = email;   //Saving for UberRequests
                handler?(nil);
            }
            
        });
    }
    //SignUp
    public func signup( email: String, pass: String, handler: ErrorHandler?)
    {
        FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
            if(error != nil)
            {
                self.HandleErrors(error: error as! NSError, handler: handler);
            }else
            {
                if user?.uid != nil {
                    
                    DBProvider.Instance.SaveUser(UID: (user?.uid)!, Email: email, Password: pass);
                    UberHandler.Instance.rider_email = email;
                    handler?(nil);
                }
            }
        });
    }
    
    private func HandleErrors (error: NSError, handler: ErrorHandler?) -> Void {
        if let errorcode = FIRAuthErrorCode(rawValue: error.code){
            
            switch(errorcode)
            {
            case .errorCodeUserNotFound:
                handler?(ErrorMesseges.invalidUser);
                break;
            case .errorCodeWrongPassword:
                handler?(ErrorMesseges.invalidPassword);
                break;
            default:
                handler?(ErrorMesseges.unknownError);
                break;
            }
        }
    }
    public func logout() -> Bool
    {
        if FIRAuth.auth()?.currentUser != nil{
            do{
                try FIRAuth.auth()?.signOut();
                return true;
            }catch{
                return false;
            }
        }
        return false;
    }
}
