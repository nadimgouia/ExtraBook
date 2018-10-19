//
//  EditProfilVC.swift
//  ChatApp
//
//  Created by N@DIM on 18/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit
import Alamofire


class EditProfilVC: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
   
    
    var avatar = ""
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var ageField: DesignableTextField!
    @IBOutlet weak var familleField: DesignableTextField!
    @IBOutlet weak var raceField: DesignableTextField!
    @IBOutlet weak var nourritureField: DesignableTextField!
    @IBOutlet weak var mdpField: DesignableTextField!
    @IBOutlet weak var confirmMdpField: DesignableTextField!
    
    @IBOutlet weak var avatarCollectioView: UICollectionView!
    @IBOutlet weak var modalView: UIView!
    
    var userId :String?
    var currentUser : User?
    
    let avatars = ["avatar1", "avatar2", "avatar3","avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //get the authentificated user id
        let defaults = UserDefaults.standard
        userId = defaults.object(forKey: "_id") as? String
        print(userId!)
        
        
        self.avatarCollectioView.delegate = self
        self.avatarCollectioView.dataSource = self
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let avatarCollectionViewCell = avatarCollectioView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarCollectionViewCell
        
        let avatar = avatars[indexPath.row]
        
        avatarCollectionViewCell.setAvatar(avatar: avatar)
        
        return avatarCollectionViewCell
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.avatar = avatars[indexPath.row]
        self.avatarImg.image = UIImage(named: avatar)
        self.modalView.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        nameField.text = currentUser!.fullName
        emailField.text = currentUser!.email
        ageField.text = String(currentUser!.age)
        familleField.text = currentUser!.famille
        raceField.text = currentUser!.race
        nourritureField.text = currentUser!.nouriture
        if currentUser!.userImage != "null" {
            avatarImg.image = UIImage(named: currentUser!.userImage)
        }
        
    }
    
    
    @IBAction func showModalAvatars(_ sender: Any) {
        
        self.modalView.alpha = 1
        
    }
    
    @IBAction func confirmUpdate(_ sender: Any) {
        
            //  il faut verifier que les champs sont remplis
            if  (nameField.text?.isEmpty)! || (familleField.text?.isEmpty)! || (ageField.text?.isEmpty)! || (emailField.text?.isEmpty)!  ||  (raceField.text?.isEmpty)! || (nourritureField.text?.isEmpty)! || (mdpField.text?.isEmpty)! || (confirmMdpField.text?.isEmpty)! {
                
                self.showAlert(alertTitle: "Erreur", alertMsg: "vous devez remplir tout les champs !")
    
            }else {
                if mdpField.text != confirmMdpField.text {
                    
                    self.showAlert(alertTitle: "Attention", alertMsg: "les mots de passe ne correspond pas !")
    
                }else {
                    // on est sure que tout les info sont rempli
                 let user : User = User(_id: "", userImage: "pic_placeholder", fullName: nameField.text!,email : emailField.text!, password : mdpField.text!, famille: familleField.text!, race: raceField.text!, nouriture: nourritureField.text! , age: Int(ageField.text!)!)
                    
                    putUpdatedData(user: user)
                }
            }

        
    }
    
    func putUpdatedData(user : User) {
        
        let parameters = [
            "fullName" : user.fullName,
            "famille": user.famille,
            "email" : user.email,
            "nouriture": user.nouriture,
            "race": user.race,
            "age": user.age,
            "password" : user.password,
            "userImage":  self.avatar,
            ] as [String : Any]
        
        let url = "http://localhost:8090/api/aliens/\(userId!)"
        
        Alamofire.request(url, method : .put, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let jsonResponse = response.result.value {
                
                guard let jsonObject = jsonResponse as? [String: Any] else {
                    return
                }
                
                let isSuccess = jsonObject["success"] as! Bool
                if isSuccess {
                    self.showAlert(alertTitle: "Felicitation", alertMsg: jsonObject["message"] as! String)
                }
                else {
                    self.showAlert(alertTitle: "Erreur",  alertMsg: "probleme de modification du compte")
                }
                
            }
        }
        
    }
    
    
    func showAlert(alertTitle : String, alertMsg : String){
        let alert: UIAlertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        
        let alertActionFermer: UIAlertAction = UIAlertAction(title: "Fermer", style: .default, handler: { action in
            alert.dismiss(animated: false, completion: nil)
            
        })
        
        alert.addAction(alertActionFermer)
        
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func dismissModal(_ sender: Any) {
        
        print("dismiss")
        self.modalView.alpha = 0
    }
    
}

    


