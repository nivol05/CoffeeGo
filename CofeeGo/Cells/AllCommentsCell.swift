//
//  AllCommentsCell.swift
//  CofeeGo
//
//  Created by NI Vol on 11/5/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Cosmos

class AllCommentsCell: UITableViewCell {

    
    @IBOutlet weak var userCommentImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
