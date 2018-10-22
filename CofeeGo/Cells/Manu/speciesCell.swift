//
//  speciesCell.swift
//  CofeeGo
//
//  Created by NI Vol on 10/15/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class speciesCell: UITableViewCell {

    @IBOutlet weak var speciesNameLbl: UILabel!
    @IBOutlet weak var checkMark: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
