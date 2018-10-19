//
//  FriendsListCell.swift
//  ChatApp
//
//  Created by N@DIM on 18/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit

protocol FriendsListCellDelegate {
    
    func openModal(index: Int)
    func addFriend(index: Int)
}

class FriendsListCell: UITableViewCell {

    @IBOutlet weak var friendImgView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var delegate:FriendsListCellDelegate?

    
    func setFriend(friend : User) {
        
        self.friendImgView.image = UIImage(named: friend.userImage)
        self.fullNameLabel.text = friend.fullName
        self.familyLabel.text = "Famille : \(friend.famille)"
        self.ageLabel.text = "Age : \(friend.age)"
        
    }
    
    
    @IBAction func btnDeleteClick(_ sender: Any) {
        
        delegate?.openModal(index: self.tag)
        
    }
    
    
    
    @IBAction func btnAddClick(_ sender: Any) {
        
       delegate?.addFriend(index: self.tag)
    }
    
    
    
    
    
    
    
}
