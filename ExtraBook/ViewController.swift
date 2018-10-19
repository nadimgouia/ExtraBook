//
//  ViewController.swift
//  ChatApp
//
//  Created by N@DIM on 15/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit
import  Alamofire

class ViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        


    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let defaults = UserDefaults.standard
        
        let userId = defaults.object(forKey: "_id") as? String
        
        if userId != nil  {
            
            // go to the next viewcontroller
            self.performSegue(withIdentifier: "homeSegue", sender: nil)
            print("here")
        }
        
    }
    
    @IBAction func logInButton(_ sender: Any) {
        
        let email = emailField.text
        let password = passwordField.text
        
        errorLabel.alpha = 0
        
        if (email?.isEmpty)! || (password?.isEmpty)! {
            
            errorLabel.text = "Vous devez remplir tout les champs !"
            errorLabel.alpha = 1
            
        }else {
            
            verifierUser(email: email!, password: password!)
            
        }
        
    }
    
    
    func verifierUser(email : String, password : String) {
        
        let parameters = [
            "email" : email,
            "password" :password,
            ]
            as [String : Any]
        
        
        Alamofire.request("http://localhost:8090/api/aliens/auth", method : .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let jsonResponse = response.result.value {
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                
                if jsonArray.count != 0 {
                    
                    for dic in jsonArray {
                        let _id = dic["_id"] as? String
                        
                        // save the id for the session
                        
                        let defaults = UserDefaults.standard
                        
                        defaults.set(_id, forKey: "_id")
                        defaults.synchronize()
                        
                        // go to the next viewcontroller
                        self.performSegue(withIdentifier: "homeSegue", sender: nil)
                    }
                    
                }
                else {
                    
                    self.errorLabel.text = "Verifier vos information"
                    self.errorLabel.alpha = 1
                    
                }

                
            }
        }
    }
    
    
    

}

