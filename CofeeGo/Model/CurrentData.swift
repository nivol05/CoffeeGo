//
//  CurrentData.swift
//  CofeeGo
//
//  Created by NI Vol on 10/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import SwiftMessages

var current_coffee_net : ElementCoffeeNet!
var current_coffee_spot : ElementCoffeeSpot!
var current_coffee_user : ElementUser!

var allCoffeeNets : [ElementCoffeeNet]!
var allSpotProducts : [ElementProduct]!
var allCoffeeSpots : [ElementCoffeeSpot]!
var userFavorites: [Int] = [Int]()
var allFavorites: [ElementFavorite]!

var isOrdered = false
var listIsVisible = false

func getActiveSpots() -> [ElementCoffeeSpot]{
    var spots = [ElementCoffeeSpot]()
    for spot in allCoffeeSpots{
        if spot.is_active{
            spots.append(spot)
        }
    }
    return spots
}

func getActiveNets() -> [ElementCoffeeNet]{
    var nets = [ElementCoffeeNet]()
    for net in allCoffeeNets{
        if net.is_active{
            nets.append(net)
        }
    }
    return nets
}

func getProductsByType(type: Int) -> [ElementProduct]{
    var prods = [ElementProduct]()
    for x in allSpotProducts{
        if x.product_type == type{
            prods.append(x)
        }
    }
    return prods
}

func getNetIndexBySpot(spot: ElementCoffeeSpot) -> Int{
    var res = -1
    for i in 0..<allCoffeeNets.count{
        if allCoffeeNets[i].id == spot.company{
            res = i
            break
        }
    }
    return res
}

func getSpotPosition(spotId: Int) -> Int{
    var res = -1
    for i in 0..<allCoffeeSpots.count{
        if spotId == allCoffeeSpots[i].id{
            res = i
            break
        }
    }
    return res
}

func getFavoritePosBySpot(spotId: Int) -> Int{
    var res = -1
    for i in 0..<allFavorites.count{
        if allFavorites[i].coffee_spot == spotId{
            res = i
            break
        }
    }
    return res
}

func getUserFavoritePos(spotPos: Int) -> Int{
    var res = -1
    for i in 0..<userFavorites.count{
        if spotPos == userFavorites[i]{
            res = i
            break
        }
    }
    return res
}

func getSpotById(spotId: Int) -> ElementCoffeeSpot{
    var res : ElementCoffeeSpot!
    for i in allCoffeeSpots{
        if spotId == i.id{
            res = i
            break
        }
    }
    return res
}

func isFavorite(spotId: Int) -> Bool{
    if allFavorites == nil{
        return false
    }
    for x in allFavorites{
        if spotId == x.coffee_spot{
            return true
        }
    }
    return false
}


