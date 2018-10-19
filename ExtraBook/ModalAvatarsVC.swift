//
//  ModalAvatarsVC.swift
//  ExtraBook
//
//  Created by N@DIM on 19/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import UIKit


class ModalAvatarsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let avatars = ["avatar1", "avatar2", "avatar3","avatar4", "avatar5", "avatar6", "avatar7", "avatar8", "avatar9"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return avatars.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let avatarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarCollectionViewCell
    
        let avatar = avatars[indexPath.row]
        avatarCollectionViewCell.tag = indexPath.row

        avatarCollectionViewCell.setAvatar(avatar: avatar)

        return avatarCollectionViewCell

    }
    
    
    

    @IBAction func dismissModal(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
}
