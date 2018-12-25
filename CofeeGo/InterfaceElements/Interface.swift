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
func cornerRatio(view : UIView, ratio : CGFloat, shadow : Bool){
    view.layer.cornerRadius = ratio
    
    view.layer.masksToBounds = true
    if shadow{
        view.layer.masksToBounds = false
    }
}

func fadeView(view : UIView, delay: TimeInterval, isHiden: Bool) {
    
    let animationDuration = 0.25
    
    // Fade in the view
    UIView.animate(withDuration: animationDuration, animations: { () -> Void in
//        view.alpha = 1
    }) { (Bool) -> Void in
        
        // After the animation completes, fade out the view after a delay
        
        UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseOut, animations: { () -> Void in
            if isHiden{
                view.alpha = 0
            } else {
                view.alpha = 1
            }
        },
                       completion: nil)
    }
}
