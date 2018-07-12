//
//  ParalaxEffectCoffeeTableView.swift
//  CofeeGo
//
//  Created by Ni VoL on 08.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class ParalaxEffectCoffeeTableView: UITableView {
    
    @IBOutlet weak var height : NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint : NSLayoutConstraint!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableHeaderView else { return }

        /// contentOffset - is a dynamic value from the top
        /// adjustedContentInset fixed valie from the top
        let offsetY = -contentOffset.y// +
        height.constant = max(header.bounds.height, header.bounds.height + offsetY)
        print(height)
        bottomConstraint.constant = offsetY >= 0 ? 0 : offsetY / 2
        header.clipsToBounds = offsetY <= 0
    }

}
