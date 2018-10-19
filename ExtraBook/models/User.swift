//
//  User.swift
//  ChatApp
//
//  Created by N@DIM on 18/10/2018.
//  Copyright © 2018 nadim. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var _id : String
    var userImage : String
    var fullName : String
    var email : String
    var famille : String
    var race : String
    var nouriture : String
    var password : String
    var age : Int
    
    init(_id : String, userImage : String, fullName : String,email : String, password : String, famille :String, race:String, nouriture : String, age:Int)
    {
        self._id = _id
        self.userImage = userImage
        self.fullName = fullName
        self.famille = famille
        self.race = race
        self.email = email
        self.nouriture = nouriture
        self.age = age
        self.password = password
    }
    
    
    
}
