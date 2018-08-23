//
//  OrderList.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class OrderList: UITableViewCell {
    
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sugarCountLbl: UILabel!
    @IBOutlet weak var coffeePrice: UILabel!
    @IBOutlet weak var priceOrderDone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BG.layer.cornerRadius = 12
        BG.layer.masksToBounds = false
        img.layer.cornerRadius = 12
        img.layer.masksToBounds = true
    }

}
