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
    @IBOutlet weak var additionalLbl: UILabel!
    @IBOutlet weak var syrypsLbl: UILabel!
    @IBOutlet weak var speciesLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerRatio(view: img, ratio: 5, shadow: false)
    }

}
