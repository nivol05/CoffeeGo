//
//  OrderItemCell.swift
//  CofeeGo
//
//  Created by NI Vol on 11/1/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class OrderItemCell: UITableViewCell {

    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sugarCountLbl: UILabel!
    @IBOutlet weak var coffeePrice: UILabel!
    @IBOutlet weak var priceOrderDone: UILabel!
    @IBOutlet weak var additionalLbl: UILabel!
    @IBOutlet weak var syrypsLbl: UILabel!
    @IBOutlet weak var speciesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerRatio(view: img, ratio: 5, shadow: false)
    }

}
