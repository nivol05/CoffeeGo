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
    
    @IBOutlet weak var heihgtLogoImage: NSLayoutConstraint!
    
    @IBOutlet weak var mainBgForDate: UIView!
    @IBOutlet weak var mainBgForTime: UIView!
    @IBOutlet weak var mainBgForPrice: UIView!
    
    @IBOutlet weak var dateBgView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timeBgView: UIView!
    @IBOutlet weak var priceBgView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var cancelOrderBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRatio(view: logoImg, ratio: 12, shadow: false)
        print(logoImg.frame.height)
        cornerRatio(view: dateBgView, ratio: 23/2, shadow: false)
        cornerRatio(view: timeBgView, ratio: 23/2, shadow: false)
        cornerRatio(view: priceBgView, ratio: 23/2, shadow: false)
        cornerRatio(view: dateLbl, ratio: 21/2, shadow: false)
        cornerRatio(view: timeLbl, ratio: 21/2, shadow: false)
        cornerRatio(view: priceLbl, ratio: 21/2, shadow: false)
        cornerRatio(view: mainBgForDate, ratio: 25/2, shadow: false)
        cornerRatio(view: mainBgForTime, ratio: 25/2, shadow: false)
        cornerRatio(view: mainBgForPrice, ratio: 25/2, shadow: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
