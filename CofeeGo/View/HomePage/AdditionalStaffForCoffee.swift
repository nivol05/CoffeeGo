//
//  AdditionalStaffForCoffee.swift
//  CofeeGo
//
//  Created by Ni VoL on 20.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import CarbonKit

class AdditionalStaffForCoffee: UIViewController, CarbonTabSwipeNavigationDelegate {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var BG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.clipsToBounds = true
        let tabSwipe = CarbonTabSwipeNavigation(items: [" Допы ","Сиропы"] , delegate: self)
        tabSwipe.setTabExtraWidth(rootView.frame.width / 3)
        tabSwipe.setTabBarHeight(56)
        tabSwipe.setSelectedColor(UIColor.black)
        tabSwipe.setIndicatorColor(UIColor.orange)
        tabSwipe.insert(intoRootViewController: self, andTargetView: rootView)
        tabSwipe.setNormalColor(UIColor.lightGray)
        
        BG.layer.cornerRadius = 12
        cancelBtn.layer.cornerRadius = 8
        confirmBtn.layer.cornerRadius = 8
        BG.layer.masksToBounds = false
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "additionalView")
        } else {
            return storyboard.instantiateViewController(withIdentifier: "syrupsView")
        }
    }


    @IBAction func confirmBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
