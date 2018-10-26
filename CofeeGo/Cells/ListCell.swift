//
//  ListCell.swift
//  CofeeGo
//
//  Created by NI Vol on 10/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var coffeeNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var dateBgView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timeBgView: UIView!
    @IBOutlet weak var priceBgView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRatio(view: dateBgView, ratio: 16, shadow: false)
        cornerRatio(view: timeBgView, ratio: 16, shadow: false)
        cornerRatio(view: priceBgView, ratio: 16, shadow: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
