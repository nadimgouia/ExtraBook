//
//  AddFriendVC.swift
//  ChatApp
//
//  Created by N@DIM on 18/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit
import Alamofire


class AddFriendVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FriendsListCellDelegate {
    
   
    func openModal(index : Int) {
        
    }
    
    func addFriend(index: Int) {
        
        print("current : \(friends[index]._id)")
        
        
        let parameters = [  "newFriend" : friends[index]._id]  as [String : Any]
        
        
        Alamofire.request("http://localhost:8090/api/aliens/friends/\(userId!)", method : .put, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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

    
    
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var friends : [User] = []
    var userId :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendTableView.dataSource = self
        self.friendTableView.delegate = self
        self.searchField.delegate = self
        
        // to remove extra empty cells from tableview
        self.friendTableView.tableFooterView = UIView()
        

        //get the authentificated user id
        let defaults = UserDefaults.standard
        userId = defaults.object(forKey: "_id") as? String
        print(userId!)
        
        populateListWithData()

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func populateListWithData() {
        
        Alamofire.request("http://localhost:8090/api/aliens/\(userId!)").responseJSON { response in
            

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
    
    
    @IBAction func searchBtnClick(_ sender: Any) {
        
        print("clicked")
        
        let url = "http://localhost:8090/api/aliens/\(userId!)/search/\(self.searchField.text!)"
        
        print(url)
        Alamofire.request(url).responseJSON { response in
            
            
            if let json = response.result.value {
                
                self.friends.removeAll()
                
                print(json)
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
}
