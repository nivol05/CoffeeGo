//
//  DropDownCell.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    @IBOutlet weak var BGSmallCup: UIView!
    @IBOutlet weak var BGMidleCuo: UIView!
    @IBOutlet weak var BGBigCup: UIView!
    
    @IBOutlet weak var heightMiddleBtn: NSLayoutConstraint!
    @IBOutlet weak var widthModdleBtn: NSLayoutConstraint!
    
    @IBOutlet weak var smallCupBtn: UIButton!
    @IBOutlet weak var middleCupBtn: UIButton!
    @IBOutlet weak var bigCubBtn: UIButton!

    @IBOutlet weak var smallCupPrice: UILabel!
    @IBOutlet weak var middleCupPrice: UILabel!
    @IBOutlet weak var bigCupPrice: UILabel!
    
    
    @IBOutlet weak var mainBG: UIView!
    @IBOutlet weak var additionsBtn: UIButton!
    @IBOutlet weak var addToOrderBtn: UIButton!
    
    @IBOutlet weak var sugarTextField: UITextField!
    
    @IBOutlet var aditionalStaff: UIButton!
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
    
    var cellExists = false
    var sugarCount : Double = 0.0
    var coffeePrice = String()
    
    var smallCupEnter = false
    var middleCupEnter = true
    var bigCupEnter = false
    
    let enterColor = UIColor(red: 1, green: 0.48, blue: 0, alpha: 1)
    let emptyColor = UIColor(white: 0.75, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        style(view: BGSmallCup, ratio: 12, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: false)
        style(view: BGMidleCuo, ratio: 12, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: false)
        style(view: BGBigCup, ratio: 12, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: false)
        style(view: mainBG, ratio: 12, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: false)
        style(view: smallCupBtn, ratio: 12, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: false)
        style(view: middleCupBtn, ratio: 12, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: false)
        style(view: bigCubBtn, ratio: 12, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: false)
        style(view: addToOrderBtn, ratio: 9, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: false)
        style(view: additionsBtn, ratio: 6, color: UIColor.black.withAlphaComponent(0.2).cgColor, shadow: true)
        
        CoffeeImg.layer.cornerRadius = 12
        CoffeeImg.layer.masksToBounds = true
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
    
    @IBAction func smallCupBtn(_ sender: Any) {
        BGSmallCup.backgroundColor = enterColor
        BGMidleCuo.backgroundColor = emptyColor
        BGBigCup.backgroundColor = emptyColor
        coffeePrice = smallCupPrice.text!
        
    }
    @IBAction func midleCupBtn(_ sender: Any) {
        BGSmallCup.backgroundColor = emptyColor
        BGMidleCuo.backgroundColor = enterColor
        BGBigCup.backgroundColor = emptyColor
        coffeePrice = middleCupPrice.text!
    }
    @IBAction func bigCupBtn(_ sender: Any) {
        BGSmallCup.backgroundColor = emptyColor
        BGMidleCuo.backgroundColor = emptyColor
        BGBigCup.backgroundColor = enterColor
        coffeePrice = bigCupPrice.text!
    }
    
    @IBAction func aditionalStaff(_ sender: Any) {
       
    }
    

    @IBAction func addToOrderList(_ sender: Any) {
        let zalupa = OrderItem(product_price: coffeePrice, product_name: nameLbl.text!, imageUrl: CoffeeImg.image! , cup_size : "m")
        OrderData.orderList.append(zalupa)
        
    }
    
    @IBAction func moreSugerBtn(_ sender: Any) {
        if sugarCount < 9{
            sugarCount += 0.5
            sugarTextField.text = "\(sugarCount)"
        }
        
    }
    @IBAction func lessSugarBtn(_ sender: Any) {
        if sugarCount > 0 {
            sugarCount -= 0.5
            sugarTextField.text = "\(sugarCount)"
        }
    }
    
}
