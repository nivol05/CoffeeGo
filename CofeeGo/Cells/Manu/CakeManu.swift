//
//  CakeManu.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class CakeManu: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var CoffeeImg: UIImageView!
    var productElem : ElementProduct!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CoffeeImg.layer.cornerRadius = 12
        CoffeeImg.layer.masksToBounds = true
//        BG.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        BG.layer.shadowOffset = CGSize(width: 0, height: 0)
//        BG.layer.shadowOpacity = 0.4
    }
    @IBAction func addElementBtn(_ sender: Any) {
        let menuElement = OrderItem(product_price: productElem.price,
                                    product_name: productElem.name,
                                    product_id : productElem.id,
                                    imageUrl: CoffeeImg.image!)
        menuElement.cup_size = "default"
        if OrderData.lessThanLimit(limit: current_coffee_spot.max_order_limit, orderItem: menuElement){
            OrderData.orderList.append(menuElement)
        } else {
            // HIGHER THAN LIMIT
            print("HIGHER THAN LIMIT")
        }
    }
}
