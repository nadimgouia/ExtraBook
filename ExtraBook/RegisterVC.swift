//
//  RegisterVC.swift
//  ChatApp
//
//  Created by N@DIM on 17/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit
import Alamofire


class RegisterVC: UIViewController {

    @IBOutlet weak var RegisterFirstStep: UIView!
    @IBOutlet weak var RegisterSecondStep: DesignableView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var fullNameField: DesignableTextField!
    @IBOutlet weak var familyField: DesignableTextField!
    @IBOutlet weak var ageField: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var raceField: DesignableTextField!
    @IBOutlet weak var nouritureField: DesignableTextField!
    @IBOutlet weak var mdpField: DesignableTextField!
    @IBOutlet weak var mdpConfirmField: DesignableTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var step :Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        flipBack()
        
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        if step == 1 {
            
        // avant de passe a l etape suivant il faut verifier que les champs sont remplis
        if  (fullNameField.text?.isEmpty)! || (familyField.text?.isEmpty)! || (ageField.text?.isEmpty)! || (emailField.text?.isEmpty)! {

            errorLabel.text = "Vous devez remplir tout les champs !"
            errorLabel.alpha = 1
            
            }
        else {
            
            errorLabel.alpha = 0
            
            flip()
            self.step = 2
            
            }
        } else {
            // on est dans la 2ieme etape
            // avant d enregistrer il faut verifier que les champs sont remplis
            if  (raceField.text?.isEmpty)! || (nouritureField.text?.isEmpty)! || (mdpField.text?.isEmpty)! || (mdpConfirmField.text?.isEmpty)! {
                
                errorLabel.text = "Vous devez remplir tout les champs !"
                errorLabel.alpha = 1
            
                
            }else {
                if mdpField.text != mdpConfirmField.text {
                    errorLabel.text = "les mots de passe ne correspond pas !"
                    errorLabel.alpha = 1
                }else {
                    // on est sure que tout les info sont rempli
                    let user : User = User(_id: "", userImage: "pic_placeholder", fullName: fullNameField.text!,email : emailField.text!, password : mdpField.text!, famille: familyField.text!, race: raceField.text!, nouriture: nouritureField.text! , age: Int(ageField.text!)!)
                    
                    postRegisterData(user: user)
                }
            }

        }
        
    }
    
    func postRegisterData(user : User) {
        
        let parameters = [
            "fullName" : user.fullName,
            "famille": user.famille,
            "email" : user.email,
            "nouriture": user.nouriture,
            "race": user.race,
            "age": user.age,
            "password" : user.password,
            "userImage": "null",
            ]
            as [String : Any]
        
        
        Alamofire.request("http://localhost:8090/api/aliens/", method : .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let jsonResponse = response.result.value {
                
                guard let jsonObject = jsonResponse as? [String: Any] else {
                    return
                }

                let isSuccess = jsonObject["success"] as! Bool
                if isSuccess {
                    self.showAlert(alertTitle: "Felicitation", alertMsg: jsonObject["message"] as! String)
                }
                else {
                    self.showAlert(alertTitle: "Erreur",  alertMsg: "probleme de creation du compte")
                }
            
            }
        }
    
    }
    
    
    func showAlert(alertTitle : String, alertMsg : String){
        let alert: UIAlertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        
        let alertActionFermer: UIAlertAction = UIAlertAction(title: "Fermer", style: .default, handler: { action in
            alert.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)

        })
        
        alert.addAction(alertActionFermer)
        
        present(alert, animated: true, completion: nil)
    }
    
    func flip() {
        
        UIView.transition(from: RegisterFirstStep, to: RegisterSecondStep, duration: 0.4, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion:{
            finished in
            // do something
            self.btnBack.alpha = 1
            print("finished")
        })
        
        
    }
    
    func flipBack() {
        
        UIView.transition(from: self.RegisterSecondStep, to: self.RegisterFirstStep, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: {
            finished in
            // do something
            self.btnBack.alpha = 0
            print("finished")
        })
        
    }

    
    
}
