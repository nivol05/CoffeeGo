//
//  Interface.swift
//  CofeeGo
//
//  Created by NI Vol on 10/9/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import UIKit

//func cornerRatio(view : UIView){
//    view.layer.cornerRadius = 5
//    view.layer.masksToBounds = false
////    backGround.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
////    backGround.layer.shadowOffset = CGSize(width: 0, height: 0)
////    backGround.layer.shadowOpacity = 0.8
//
//}
func cornerRatio(view : UIView, ratio : CGFloat, color : CGColor, shadow : Bool){
    view.layer.cornerRadius = ratio
    view.layer.masksToBounds = false
    if shadow{
        view.layer.shadowColor = color
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.4
    }
}
