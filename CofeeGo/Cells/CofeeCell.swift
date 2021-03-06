//
//  CofeeCell.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.05.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class CofeeCell: UITableViewCell {

    var LC : ListCoffee!
    var VC : ViewController!
    

    @IBOutlet weak var heightCoffeeImg: NSLayoutConstraint!
    @IBOutlet weak var CofeeImg: UIImageView!
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rateStars: CosmosView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var metroLbl: UILabel!
    @IBOutlet weak var metroLineImg: UIImageView!
    //    @IBOutlet weak var backGround: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroungStyle()
        
        cornerRatio(view: previewImg, ratio: 70 / 2, shadow: false)
        
//        let screenWidth = UIScreen.main.bounds.size.height
        
//        heightCoffeeImg.constant = screenWidth / 1.7777778
    }

    func configureCell(listCoffee : ListCoffee){
        nameLbl.text = listCoffee.name
    }
    
    func backgroungStyle(){
//        backGround.layer.cornerRadius = 12
//        backGround.layer.masksToBounds = false
//        backGround.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        backGround.layer.shadowOffset = CGSize(width: 0, height: 0)
//        backGround.layer.shadowOpacity = 0.8
        
    }

}
