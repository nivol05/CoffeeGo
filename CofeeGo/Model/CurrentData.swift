//
//  CurrentData.swift
//  CofeeGo
//
//  Created by NI Vol on 10/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

var current_coffee_net : ElementCoffeeNet!
var current_coffee_spot : ElementCoffeeSpot!
var current_coffee_user : ElementUser!

var allCoffeeNets : [ElementCoffeeNet]!
var allSpotProducts : [ElementProduct]!
var allCoffeeSpots : [ElementCoffeeSpot]!

func getProductsByType(type: Int) -> [ElementProduct]{
    var prods = [ElementProduct]()
    for x in allSpotProducts{
        if x.product_type == type{
            prods.append(x)
        }
    }
    return prods
}
