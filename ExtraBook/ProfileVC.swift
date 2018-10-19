//
//  GroupsVC.swift
//  ChatApp
//
//  Created by N@DIM on 17/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController {


    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var ageText: UILabel!
    @IBOutlet weak var familleText: UILabel!
    @IBOutlet weak var raceText: UILabel!
    @IBOutlet weak var nourritureText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    var userId :String?
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //get the authentificated user id
        let defaults = UserDefaults.standard
        userId = defaults.object(forKey: "_id") as? String
        print(userId!)
        
        loadAlienInfo()
    }

    
    
    func loadAlienInfo() {
    
        let url = "http://localhost:8090/api/alien/\(userId!)"
        
        Alamofire.request(url).responseJSON { response in
            
            if let jsonResponse = response.result.value {
                
                guard let jsonObject = jsonResponse as? [String: Any] else {
                    return
                }
                
                let _id = jsonObject["_id"] as? String
                let fullName = jsonObject["fullName"] as? String
                let email = jsonObject["email"] as? String
                let famille = jsonObject["famille"] as? String
                let race = jsonObject["race"] as? String
                let nouriture = jsonObject["nouriture"] as? String
                let userImage = jsonObject["userImage"] as? String
                let age = jsonObject["age"] as? Int
                
                
                self.user  = User(_id: _id!, userImage: userImage!, fullName: fullName!, email : email!, password: "" ,famille: famille!, race: race!, nouriture: nouriture!, age: age!)
                
                
                self.fullNameText.text = fullName
                self.emailText.text = email
                self.familleText.text = famille
                self.raceText.text = race
                self.nourritureText.text = nouriture
                self.userImage.image = UIImage(named: userImage!)
                
                self.ageText.text = "\(age!) ans"

                
                
            }
        }
        
    
    }

    @IBAction func editClicked(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let editProfilVC = segue.destination as! EditProfilVC
            
            editProfilVC.currentUser = self.user
        }
    }
    

}
