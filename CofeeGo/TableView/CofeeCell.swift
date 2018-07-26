//
//  CofeeCell.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.05.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Kingfisher

class CofeeCell: UITableViewCell {

    var LC : ListCoffee!
    var VC : ViewController!
    
    @IBOutlet weak var widthCoffeeImg: NSLayoutConstraint!
    @IBOutlet weak var heightCoffeeImg: NSLayoutConstraint!
    @IBOutlet weak var CofeeImg: UIImageView!
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backGround: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroungStyle()
        
        previewImg.layer.cornerRadius = self.CofeeImg.frame.width / 2
        let screenWidth = UIScreen.main.bounds.size.width
        
        heightCoffeeImg.constant = screenWidth / 1.7777778
    }

    func configureCell(listCoffee : ListCoffee){
        nameLbl.text = listCoffee.name
    }
    
    func backgroungStyle(){
        backGround.layer.cornerRadius = 12
        backGround.layer.masksToBounds = false
        backGround.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backGround.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGround.layer.shadowOpacity = 0.8
        
    }

}
