//
//  LoginVC.swift
//  Uber For Rider
//
//  Created by Haider Rasool on 3/31/17.
//  Copyright © 2017 Haider Rasool. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var tb_email: UITextField!
    @IBOutlet weak var tb_password: UITextField!
    let Segue_RiderVC = "RiderVC";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action_login(_ sender: Any) {
        if(self.tb_email.text != "" && self.tb_password.text != "")
        {
            AuthProvider.Instance.login(email: tb_email.text!, pass: tb_password.text!, handler: { (errormsg) in
                if errormsg != nil {
                    self.showAlert(msg: errormsg!, title: "Authentication Error");
                }else
                {
                    //self.showAlert(msg: "Success! You are now logged in.", title: "Authenticated");
                    self.performSegue(withIdentifier: self.Segue_RiderVC, sender: nil);
                }
            });
        }else
        {
            self.showAlert(msg: "Error! Email and Password fields are required.", title: "Authentication Error");
        }
    }
    
    @IBAction func action_signup(_ sender: Any) {
        if(self.tb_email.text != "" && self.tb_password.text != "")
        {
            AuthProvider.Instance.signup(email: tb_email.text!, pass: tb_password.text!, handler: { (errormsg) in
                if errormsg != nil {
                    self.showAlert(msg: errormsg!, title: "Authentication Error");
                }else
                {
                    //self.showAlert(msg: "Success! You are now logged in.", title: "Authenticated");
                    self.performSegue(withIdentifier: self.Segue_RiderVC, sender: nil);
                }
            });
        }else
        {
            self.showAlert(msg: "Error! Email and Password fields are required.", title: "Authentication Error");
        }
    }
    
    func showAlert( msg:String, title: String)
    {
        let alertctrl = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        let okbtn = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alertctrl.addAction(okbtn);
        present(alertctrl, animated: true, completion: nil);
    }
}

