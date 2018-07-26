//
//  DropDownCell.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    @IBOutlet weak var SmollcubBtn: UIButton!
    @IBOutlet weak var midleCubBtn: UIButton!
    @IBOutlet weak var bigCubBtn: UIButton!
    @IBOutlet weak var mainBG: UIView!
    @IBOutlet weak var additionsBtn: UIButton!
    @IBOutlet weak var addToOrderBtn: UIButton!
    
    var cellExists : Bool = false
    
    @IBOutlet var open: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var CoffeeImg: UIImageView!
    @IBOutlet var stuffView: UIView! {
        didSet {
            stuffView?.isHidden = true
            stuffView?.alpha = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style(view: mainBG, ratio: 12, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: true)
//        style(view: CoffeeImg, ratio: 12, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: false)
        style(view: SmollcubBtn, ratio: 12, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: true)
        style(view: midleCubBtn, ratio: 12, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: true)
        style(view: bigCubBtn, ratio: 12, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: true)
        style(view: addToOrderBtn, ratio: 9, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: false)
        style(view: additionsBtn, ratio: 6, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: false)
        
//        mainBG.layer.cornerRadius = 12
        CoffeeImg.layer.cornerRadius = 12
//        mainBG.layer.masksToBounds = false
        CoffeeImg.layer.masksToBounds = true
//        mainBG.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        mainBG.layer.shadowOffset = CGSize(width: 0, height: 0)
//        mainBG.layer.shadowOpacity = 0.4
    }
    
    func style(view : UIView, ratio : CGFloat, color : CGColor, shadow : Bool){
        view.layer.cornerRadius = ratio
        view.layer.masksToBounds = false
        if shadow{
            view.layer.shadowColor = color
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowOpacity = 0.4
        }
    }
    
    func animate(duration: Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                self.stuffView.isHidden = !self.stuffView.isHidden
                if self.stuffView.alpha == 1 {
                    self.stuffView.alpha = 0
                }
                else {
                    self.stuffView.alpha = 1
                }
                
            })
        }, completion: {  (finished: Bool) in
//            print("animation complete")
            c()
        })
    }
}
