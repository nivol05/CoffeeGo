//
//  SyrupCell.swift
//  CofeeGo
//
//  Created by Ni VoL on 24.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class SyrupCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var syrupNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
