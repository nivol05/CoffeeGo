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
    
     var product_price : String!
     var product_name : String!
     var imageUrl : UIImage!
     var sugar : Double!
     var cup_size : String!
     var syrups = [String]()
     var species = [String]()
    
    init(product_price : String ,product_name : String, imageUrl : UIImage , cup_size : String ) {
        self.product_name = product_name
        self.product_price = product_price
        self.imageUrl = imageUrl
        self.cup_size = cup_size
//        self.sugar = sugar
    }
    init(product_price : String ,product_name : String, imageUrl : UIImage) {
        self.product_name = product_name
        self.product_price = product_price
        self.imageUrl = imageUrl
        self.cup_size = "default"
    }
    
    func setSugar(sugar : Double){
        self.sugar = sugar
    }
    
    func  getSugar() -> Double {
        if sugar == nil{
            return 0.0
        }
        return sugar
    }
    
    func  getName() -> String {

        return product_name
    }
    func  getImage() -> UIImage {
        
        return imageUrl
    }

    
    
}
