//
//  CommentTable.swift
//  CofeeGo
//
//  Created by Ni VoL on 01.06.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class CommentTable: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var personImg: UIImageView!
    @IBOutlet weak var backGround: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroungStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func backgroungStyle(){
        
        backGround.layer.cornerRadius = 12
        backGround.layer.masksToBounds = false
        backGround.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backGround.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGround.layer.shadowOpacity = 0.5
        
    }
}
