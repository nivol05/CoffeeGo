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
    @IBOutlet weak var missingitemLbl: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerRatio(view: CoffeeImg, ratio: 5, shadow: false)
//        BG.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        BG.layer.shadowOffset = CGSize(width: 0, height: 0)
//        BG.layer.shadowOpacity = 0.4
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
