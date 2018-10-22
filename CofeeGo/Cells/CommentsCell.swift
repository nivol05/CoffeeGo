//
//  CommentsCell.swift
//  CofeeGo
//
//  Created by NI Vol on 10/8/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Cosmos

class CommentsCell: UICollectionViewCell {
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var rateInComments: CosmosView!
    
    func corner(){
        BGView.layer.cornerRadius = 5
        BGView.layer.masksToBounds = false
    }
    
    
}
