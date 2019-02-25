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
    static var countSyryps = 0
    
    static var tempSpecies = [[String : Any]]()
    static var currSpecies = [[String : Any]]()
    static var countSpecies = 0
    
    static var tempAdditionals = [[String : Any]]()
    static var currAdditionals = [[String : Any]]()
    static var countAdditionals = 0
    
    static var controller : OrderListVC!
    
    
    static func lessThanLimit(limit : String, orderItem : OrderItem) -> Bool{
        let nextPrice = getAllPrice() + orderItem.getProductPrice()
        return nextPrice < Int(limit)!;
    }
    
    static func clearAll(){
        tempAdditionals.removeAll()
        tempSyrups.removeAll()
        tempSpecies.removeAll()
        currAdditionals.removeAll()
        currSyrups.removeAll()
        currSpecies.removeAll()
        countSyryps = 0
        countSpecies = 0
        countAdditionals = 0
    }
    
    static func getAllPrice() -> Int{
    var all = 0;
    
        for x in orderList{
            all = all + x.getProductPrice()
        }
    
        return all;
    }
}

