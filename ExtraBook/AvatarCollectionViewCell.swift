//
//  AvatarCollectionViewCell.swift
//  ExtraBook
//
//  Created by N@DIM on 19/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
        
    @IBOutlet weak var avatarImg: DesignableImageView!
    
    func setAvatar(avatar : String){
        
        self.avatarImg.image = UIImage(named: avatar)

    }
    
    
    
    
    
    
    
}
