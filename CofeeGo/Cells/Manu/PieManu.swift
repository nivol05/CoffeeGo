//
//  PieManu.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class PieManu: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var CoffeeImg: UIImageView!
    var productElem : ElementProduct!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        CoffeeImg.layer.cornerRadius = 12
        
        CoffeeImg.layer.masksToBounds = true

    }
    @IBAction func addElementBtn(_ sender: Any) {
        let menuElement = OrderItem(product_price: productElem.price,
                                    product_name: productElem.name,
                                    product_id : productElem.id,
                                    imageUrl: CoffeeImg.image!)
        OrderData.orderList.append(menuElement)
    }

}
