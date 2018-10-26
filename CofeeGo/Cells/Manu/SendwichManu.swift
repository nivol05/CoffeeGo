//
//  SendwichManu.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class SendwichManu: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var CoffeeImg: UIImageView!
    var productElem = [String : Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CoffeeImg.layer.cornerRadius = 12
        CoffeeImg.layer.masksToBounds = true

    }
    @IBAction func addElementBtn(_ sender: Any) {
        let menuElement = OrderItem(product_price: productElem["price"] as! Int,
                                    product_name: productElem["name"] as! String,
                                    product_id : productElem["id"] as! Int,
                                    imageUrl: CoffeeImg.image!)
        if OrderData.lessThanLimit(limit: current_coffee_spot.max_order_limit, orderItem: menuElement){
            OrderData.orderList.append(menuElement)
        } else {
            // HIGHER THAN LIMIT
            print("HIGHER THAN LIMIT")
        }
    }
}
