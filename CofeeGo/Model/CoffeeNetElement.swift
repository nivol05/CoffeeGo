//
//  CoffeeNetElement.swift
//  CofeeGo
//
//  Created by NI Vol on 10/23/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

class CoffeeNetElement{
    var id : Int
    var name : String
    var name_other : String
    var is_active : Bool
    var img : String
    var logo_img : String
    var stars : Double
    var description_full : String

    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        name = mas["name"] as! String
        name_other = mas["name_other"] as! String
        is_active = mas["is_active"] as! Bool
        img = mas["img"] as! String
        logo_img = mas["logo_img"] as! String
        stars = mas["stars"] as! Double
        description_full = mas["description_full"] as! String
    }
}
