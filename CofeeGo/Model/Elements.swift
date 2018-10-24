//
//  CoffeeNetElement.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.10.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

class ElementCoffeeNet{
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

class ElementCoffeeSpot{
    var id : Int
    var company : Int
    var lat : String
    var lng : String
    var address : String
    var time_start : String
    var time_finish : String
    var max_order_time : String
    var max_order_limit : String
    var is_active : Bool
    var metro_station : String
    var card_payment : Bool
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        company = mas["name"] as! Int
        lat = mas["lat"] as! String
        lng = mas["lng"] as! String
        address = mas["address"] as! String
        time_start = mas["time_start"] as! String
        time_finish = mas["time_finish"] as! String
        max_order_time = mas["max_order_time"] as! String
        max_order_limit = mas["max_order_limit"] as! String
        is_active = mas["is_active"] as! Bool
        metro_station = mas["metro_station"] as! String
        card_payment = mas["card_payment"] as! Bool
    }
}

class ElementComment{
    var url : String
    var user : Int
    var id : Int
    var coffee_net : Int
    var comment : String
    var stars : Double
    var date : String
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        user = mas["user"] as! Int
        url = mas["url"] as! String
        coffee_net = mas["coffee_net"] as! Int
        comment = mas["comment"] as! String
        stars = mas["stars"] as! Double
        date = mas["date"] as! String
    }
}

class ElementOrderItem{
    var url : String
    var id : Int
    var order : Int
    var product : Int
    var sugar : Double
    var additionals : String
    var syrups : String
    var species : String
    var item_price : Int
    var additionals_price : Int
    var cup_size : String
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        order = mas["order"] as! Int
        url = mas["url"] as! String
        product = mas["product"] as! Int
        cup_size = mas["cup_size"] as! String
        sugar = mas["sugar"] as! Double
        additionals = mas["additionals"] as! String
        syrups = mas["syrups"] as! String
        species = mas["species"] as! String
        item_price = mas["item_price"] as! Int
        additionals_price = mas["additionals_price"] as! Int
    }
}

class ElementOrder{
    var id : Int
    var user : Int
    var coffee_spot : Int
    var full_price : Int
    var date : String
    var comment : String
    var order_time : String
    var status : Int
    var canceled_barista_message : String
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        user = mas["user"] as! Int
        coffee_spot = mas["coffee_spot"] as! Int
        full_price = mas["full_price"] as! Int
        date = mas["date"] as! String
        comment = mas["comment"] as! String
        order_time = mas["order_time"] as! String
        status = mas["status"] as! Int
        canceled_barista_message = mas["canceled_barista_message"] as! String
    }
}

class ElementProduct{
    var id : Int
    var name : String
    var coffee_spot : Int
    var product_type : Int
    var img : String
    var price : Int
    var l_cup : Int
    var m_cup : Int
    var b_cup : Int
    var active : Bool
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        name = mas["name"] as! String
        coffee_spot = mas["coffee_spot"] as! Int
        product_type = mas["product_type"] as! Int
        img = mas["img"] as! String
        price = mas["price"] as! Int
        l_cup = mas["l_cup"] as! Int
        m_cup = mas["m_cup"] as! Int
        b_cup = mas["b_cup"] as! Int
        active = mas["active"] as! Bool
    }
}
