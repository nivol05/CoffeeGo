//
//  CoffeeManu.swift
//  CofeeGo
//
//  Created by Ni VoL on 17.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class CoffeeManu: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var CoffeeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CoffeeImg.layer.cornerRadius = 12

    }
//    @IBAction func addElementBtn(_ sender: Any) {
//        let menuElement = OrderItem(product_price: priceLbl.text!, product_name: nameLbl.text!, imageUrl: CoffeeImg.image!)
//        OrderData.orderList.append(menuElement)
//    }
}
