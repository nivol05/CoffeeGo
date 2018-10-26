//
//  OrderData.swift
//  CofeeGo
//
//  Created by Ni VoL on 04.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

class OrderData{
    static var orderList : [OrderItem] = [OrderItem]()
    
    static var tempSyrups = [[String : Any]]()
    static var currSyrups = [[String : Any]]()
    
    static var tempSpecies = [String]()
    static var currSpecies = [String]()
    
    static var tempAdditionals = [[String : Any]]()
    static var currAdditionals = [[String : Any]]()
    
    static func lessThanLimit(limit : String, orderItem : OrderItem) -> Bool{
        let nextPrice = getAllPrice() + orderItem.product_price
        return nextPrice < Int(limit)!;
    }
    
    static func getAllPrice() -> Int{
    var all = 0;
    
        for x in orderList{
            all = all + x.getProductPrice()
        }
    
        return all;
    }
}

