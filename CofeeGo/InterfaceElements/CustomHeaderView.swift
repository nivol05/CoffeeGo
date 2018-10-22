//
//  CustomHeaderView.swift
//  CofeeGo
//
//  Created by NI Vol on 10/4/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {

    @IBOutlet var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.preferredMaxLayoutWidth = label.bounds.width
    }
}
