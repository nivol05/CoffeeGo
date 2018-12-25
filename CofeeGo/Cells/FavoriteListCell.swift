//
//  FavoriteListCell.swift
//  CofeeGo
//
//  Created by NI Vol on 11/6/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Cosmos

class FavoriteListCell: UITableViewCell {

    
    @IBOutlet weak var heightCoffeeImg: NSLayoutConstraint!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rateStars: CosmosView!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var metroLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
