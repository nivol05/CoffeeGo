//
//  ConerRatio.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.06.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class ConerRatio: UIView {
    
    func backgroungStyle(view : ConerRatio){
        
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        
    }
    

}
