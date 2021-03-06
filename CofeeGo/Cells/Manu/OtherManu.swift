//
//  OtherManu.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class OtherManu: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var CoffeeImg: UIImageView!
    @IBOutlet weak var missingItemLbl: UIStackView!
    
    var productElem : ElementProduct!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerRatio(view: CoffeeImg, ratio: 5, shadow: false)
    }
    @IBAction func addElementBtn(_ sender: Any) {
        if productElem.active{
            let menuElement = OrderItem(product_price: productElem.price,
                                        product_name: productElem.name,
                                        product_id : productElem.id,
                                        imageUrl: CoffeeImg.image!)
            menuElement.cup_size = "default"
            if OrderData.lessThanLimit(limit: current_coffee_spot.max_order_limit, orderItem: menuElement){
                OrderData.orderList.append(menuElement)
                OrderData.controller.tableView.reloadData()
                OrderData.controller.updateLbls()
                makeToast("Добавлено к заказу")
            } else {
                makeToast("Превышен лимит заказа")
                print("HIGHER THAN LIMIT")
            }
        }
    }
}
