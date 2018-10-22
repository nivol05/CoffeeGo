//
//  OrderItem.swift
//  CofeeGo
//
//  Created by Ni VoL on 04.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import UIKit
public class OrderItem{
    
     var product_price : Int!
     var product_name : String!
    var product_id : Int!
     var imageUrl : UIImage!
     var sugar : Double!
     var cup_size : String!
    var syrupPrice : Int!
    var syrups = [[String : Any]]()
     var species = [String]()
    var additionals = [[String : Any]]()
    
    init(product_price : Int ,product_name : String, product_id : Int, imageUrl : UIImage , cup_size : String ) {
        self.product_name = product_name
        self.product_price = product_price
        self.product_id = product_id
        self.imageUrl = imageUrl
        self.cup_size = cup_size
//        self.sugar = sugar
    }
    init(product_price : Int ,product_name : String, product_id : Int,  imageUrl : UIImage) {
        self.product_name = product_name
        self.product_id = product_id
        self.product_price = product_price
        self.imageUrl = imageUrl
        self.cup_size = "default"
    }
    
    func getProductPrice() -> Int{
        var price : Int = product_price
        if syrups.count > 0{
            for x in syrups{
                let syrupPrice = x["price"] as! Int
                price = price + syrupPrice
            }
        }
        
        if additionals.count > 0{
            for x in additionals{
                let addPrice = x["price"] as! Int
                price = price + addPrice
            }
        }
        return price
    }
    
    func getSyrupsString() -> String{
        var resp : String = ""
        if syrups.count > 0{
            for x in 0..<syrups.count{
                let name = syrups[x]["name"] as! String
                resp.append(name)
                if x != syrups.count - 1{
                    resp.append(", ")
                }
            }
        }
        
        return resp
    }
    
    func getSpeciesString() -> String{
        var resp : String = ""
        if species.count > 0{
            for x in 0..<species.count{
                let name = species[x]
                resp.append(name)
                if x != species.count - 1{
                    resp.append(", ")
                }
            }
        }
        
        return resp
    }
    
    func getAdditionalsString() -> String{
        var resp : String = ""
        if additionals.count > 0{
            for x in 0..<additionals.count{
                let name = additionals[x]["name"] as! String
                resp.append(name)
                if x != additionals.count - 1{
                    resp.append(", ")
                }
            }
        }
        
        return resp
    }
}
