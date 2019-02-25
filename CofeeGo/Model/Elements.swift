//
//  CoffeeNetElement.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.10.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

func setElementCoffeeNetList(list: [[String : Any]]) -> [ElementCoffeeNet]{
    var ret = [ElementCoffeeNet]()
    for x in list{
        ret.append(ElementCoffeeNet(mas: x))
    }
    return ret
}

func setElementCoffeeSpotList(list: [[String : Any]]) -> [ElementCoffeeSpot]{
    var ret = [ElementCoffeeSpot]()
    for x in list{
        ret.append(ElementCoffeeSpot(mas: x))
    }
    return ret
}

func setElementProductList(list: [[String : Any]]) -> [ElementProduct]{
    var ret = [ElementProduct]()
    for x in list{
        ret.append(ElementProduct(mas: x))
    }
    return ret
}

func setElementUserList(list: [[String : Any]]) -> [ElementUser]{
    var ret = [ElementUser]()
    for x in list{
        ret.append(ElementUser(mas: x))
    }
    return ret
}

func setElementOrderList(list: [[String : Any]]) -> [ElementOrder]{
    var ret = [ElementOrder]()
    for x in list{
        ret.append(ElementOrder(mas: x))
    }
    return ret
}

func setElementOrderItemList(list: [[String : Any]]) -> [ElementOrderItem]{
    var ret = [ElementOrderItem]()
    for x in list{
        ret.append(ElementOrderItem(mas: x))
    }
    return ret
}

func setElementCommentList(list: [[String : Any]]) -> [ElementComment]{
    var ret = [ElementComment]()
    for x in list{
        ret.append(ElementComment(mas: x))
    }
    return ret
}

func setElementFavoriteList(list: [[String : Any]]) -> [ElementFavorite]{
    var ret = [ElementFavorite]()
    for x in list{
        ret.append(ElementFavorite(mas: x))
    }
    return ret
}

class ElementCoffeeNet{
    var id : Int!
    var name : String!
    var name_other : String!
    var is_active : Bool!
    var img : String!
    var logo_img : String!
    var stars : Double!
    var description_full : String!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        name = mas["name"] as? String
        name_other = mas["name_other"] as? String
        is_active = mas["is_active"] as? Bool
        img = mas["img"] as? String
        logo_img = mas["logo_img"] as? String
        stars = mas["stars"] as? Double
        description_full = mas["description_full"] as? String
    }
}

class ElementCoffeeSpot{
    var id : Int!
    var company : Int!
    var lat : String!
    var lng : String!
    var address : String!
    var time_start : String!
    var time_finish : String!
    var max_order_time : String!
    var max_order_limit : String!
    var min_order_time : String!
    var is_active : Bool!
    var is_closed : Bool!
    var metro_station : String!
    var card_payment : Bool!
    var takeaway : Bool!
    var img : String!
    var stars : Double!
    var description_full : String!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        company = mas["name"] as? Int
        lat = mas["lat"] as? String
        lng = mas["lng"] as? String
        address = mas["address"] as? String
        time_start = mas["time_start"] as? String
        time_finish = mas["time_finish"] as? String
        max_order_time = mas["max_order_time"] as? String
        max_order_limit = mas["max_order_limit"] as? String
        min_order_time = mas["min_order_time"] as? String
        is_active = mas["is_active"] as? Bool
        is_closed = mas["is_closed"] as? Bool
        metro_station = mas["metro_station"] as? String
        card_payment = mas["card_payment"] as? Bool
        takeaway = mas["takeaway"] as? Bool
        img = mas["img"] as? String
        stars = mas["stars"] as? Double
        description_full = mas["description_full"] as? String
    }
}

class ElementComment{
    var url : String!
    var user : Int!
    var id : Int!
    var coffee_net : Int!
    var comment : String!
    var stars : Double!
    var date : String!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        user = mas["user"] as? Int
        url = mas["url"] as? String
        coffee_net = mas["coffee_net"] as? Int
        comment = mas["comment"] as? String
        stars = mas["stars"] as? Double
        date = mas["date"] as? String
    }
}

class ElementOrderItem{
    var url : String!
    var id : Int!
    var order : Int!
    var product : Int!
    var sugar : Double!
    var additionals : String!
    var syrups : String!
    var species : String!
    var item_price : Int!
    var additionals_price : Int!
    var cup_size : String!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        order = mas["order"] as? Int
        url = mas["url"] as? String
        product = mas["product"] as? Int
        cup_size = mas["cup_size"] as? String
        sugar = mas["sugar"] as? Double
        additionals = mas["additionals"] as? String
        syrups = mas["syrups"] as? String
        species = mas["species"] as? String
        item_price = mas["item_price"] as? Int
        additionals_price = mas["additionals_price"] as? Int
    }
}

class ElementOrder{
    var id : Int!
    var user : Int!
    var coffee_spot : Int!
    var full_price : Int!
    var date : String!
    var comment : String!
    var order_time : String!
    var status : Int!
    var canceled_barista_message : String!
    var takeaway : Bool!
    var delayed_order: Bool!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        user = mas["user"] as? Int
        coffee_spot = mas["coffee_spot"] as? Int
        full_price = mas["full_price"] as? Int
        date = mas["date"] as? String
        comment = mas["comment"] as? String
        order_time = mas["order_time"] as? String
        status = mas["status"] as? Int
        canceled_barista_message = mas["canceled_barista_message"] as? String
        takeaway = mas["takaaway"] as? Bool
        delayed_order = mas["delayed_order"] as? Bool
    }
}

class ElementProduct{
    var id : Int!
    var name : String!
    var coffee_spot : Int!
    var product_type : Int!
    var img : String!
    var price : Int!
    var l_cup : Int!
    var m_cup : Int!
    var b_cup : Int!
    var active : Bool!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        name = mas["name"] as? String
        coffee_spot = mas["coffee_spot"] as? Int
        product_type = mas["product_type"] as? Int
        img = mas["img"] as? String
        price = mas["price"] as? Int
        l_cup = mas["l_cup"] as? Int
        m_cup = mas["m_cup"] as? Int
        b_cup = mas["b_cup"] as? Int
        active = mas["active"] as? Bool
    }
}

class ElementUser{
    var id : Int!
    var first_name : String!
    var password : String!
    var username : String!
    
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        first_name = mas["first_name"] as? String
        password = mas["password"] as? String
        username = mas["username"] as? String
    }
}

class ElementFavorite{
    var id : Int!
    var user : Int!
    var coffee_net : Int!
    var coffee_spot : Int!
    
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        user = mas["user"] as? Int
        coffee_net = mas["coffee_net"] as? Int
        coffee_spot = mas["coffee_spot"] as? Int
    }
}
