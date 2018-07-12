//
//  CoffeeListOnMap.swift
//  CofeeGo
//
//  Created by Ni VoL on 07.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class CoffeeListOnMap: UITableViewCell {
    @IBOutlet weak var adreesCoffee: UILabel!
    
    @IBOutlet weak var BG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
            BG.layer.cornerRadius = 12
            BG.layer.masksToBounds = false
            BG.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            BG.layer.shadowOffset = CGSize(width: 0, height: 0)
            BG.layer.shadowOpacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
