//
//  FriendsVC.swift
//  ChatApp
//
//  Created by N@DIM on 18/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit
import Alamofire

class FriendsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendsListCellDelegate {
   
    
    func addFriend(index: Int) {
        
    }

    
    func openModal(index: Int) {
        
        let alert: UIAlertController = UIAlertController(title: "Confirmation !", message: "Etes-vous sure de vouloir supprimer cet amis ?", preferredStyle: .alert)
        let alertActionAnnuler: UIAlertAction = UIAlertAction(title: "Annuler", style: .default, handler: { action in
            alert.dismiss(animated: false, completion: nil)
        })
        
        let alertActionConfirm: UIAlertAction = UIAlertAction(title: "Oui", style: .default, handler: { action in
            self.deleteFriend(index: index)
        })
        
        alert.addAction(alertActionAnnuler)
        alert.addAction(alertActionConfirm)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var friends : [User] = []
    var userId :String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.friendTableView.dataSource = self
        self.friendTableView.delegate = self
        
        // to remove extra empty cells from tableview
        self.friendTableView.tableFooterView = UIView()
        
        //get the authentificated user id
        let defaults = UserDefaults.standard
        userId = defaults.object(forKey: "_id") as? String
        print(userId!)
        
        populateListWithData()

    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "_id")
        dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let friend = friends[indexPath.row]
        
        let cell = self.friendTableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendsListCell
        cell.tag = indexPath.row

        cell.setFriend(friend: friend)
        cell.delegate = self
        
        return cell
    }
    
    
    func populateListWithData() {
        
        Alamofire.request("http://localhost:8090/api/aliens/friends/\(userId!)").responseJSON { response in
            
            
            if let json = response.result.value {
                
                guard let jsonArray = json as? [[String: Any]] else {
                    return
                }
                
                for dic in jsonArray{
                    let _id = dic["_id"] as? String
                    let fullName = dic["fullName"] as? String
                    let famille = dic["famille"] as? String
                    let race = dic["race"] as? String
                    let nouriture = dic["nouriture"] as? String
                    let age = dic["age"] as? Int
                    
                    
                    let friend  = User(_id: _id!, userImage: "pic_placeholder", fullName: fullName!, email : "alien@gmail.com", password: "" ,famille: famille!, race: race!, nouriture: nouriture!, age: age!)
                    
                    self.friends.append(friend)
                    
                }
                
                print( self.friends.count)
                
            }
            
            self.friendTableView.reloadData()
            
        }

    }
    
    
    func deleteFriend(index: Int) {
        
        print("current : \(friends[index]._id)")
        print("index : \(index)")
        
        let parameters = [  "friendToDelete" : friends[index]._id]  as [String : Any]
        
        
        Alamofire.request("http://localhost:8090/api/aliens/friends/\(userId!)", method : .delete, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
        
        if let jsonResponse = response.result.value {
        print(jsonResponse)
      
       guard let jsonObject = jsonResponse as? [String: Any] else {
            return
        }
       
        let isSuccess = jsonObject["success"] as! Bool
            
            if isSuccess {
                self.showAlert(alertTitle: "Felicitation", alertMsg: jsonObject["message"] as! String, index: index)
            }
            else {
                self.showAlert(alertTitle: "Erreur",  alertMsg: jsonObject["message"] as! String, index: index)
            }
        
           }
        }
        
    }

    
    func showAlert(alertTitle : String, alertMsg : String, index :Int){
        let alert: UIAlertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        
        let alertActionFermer: UIAlertAction = UIAlertAction(title: "Fermer", style: .default, handler: { action in
            alert.dismiss(animated: false, completion: nil)
            // refresh tableview without added friend
            self.friends.remove(at: index)
            self.friendTableView.reloadData()
        })
        
        alert.addAction(alertActionFermer)
        
        present(alert, animated: true, completion: nil)
    }

    
}
