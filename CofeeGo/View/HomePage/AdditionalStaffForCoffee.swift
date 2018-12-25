//
//  AdditionalStaffForCoffee.swift
//  CofeeGo
//
//  Created by Ni VoL on 20.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import CarbonKit
import XLPagerTabStrip



class AdditionalStaffForCoffee: ButtonBarPagerTabStripViewController {
    
    var tabs = [Int]()


    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var BG: UIView!
    
    
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .systemFont(ofSize: 18, weight: UIFont.Weight.light)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = UIColor.white
        }
        
        super.viewDidLoad()
        rootView.clipsToBounds = true
//        let tabSwipe = CarbonTabSwipeNavigation(items: [" Допы ","Сиропы", "Специи"] , delegate: self)
//        tabSwipe.setTabExtraWidth(rootView.frame.width / 3)
//        tabSwipe.setTabBarHeight(56)
//        tabSwipe.setSelectedColor(UIColor.black)
//        tabSwipe.setIndicatorColor(UIColor.orange)
//        tabSwipe.insert(intoRootViewController: self, andTargetView: rootView)
//        tabSwipe.setNormalColor(UIColor.lightGray)
//        
        cornerRatio(view: BG, ratio: 5, shadow: false)
        cornerRatio(view: cancelBtn, ratio: 5, shadow: false)
        cornerRatio(view: confirmBtn, ratio: 5, shadow: false)

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "additionalView")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "syrupsView")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "speciesView")
        
        return [child_1, child_2, child_3]
        
    }
    
//    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
//        guard let storyboard = storyboard else { return UIViewController() }
//        if index == 0 {
//            return storyboard.instantiateViewController(withIdentifier: "additionalView")
//        } else if index == 1 {
//            return storyboard.instantiateViewController(withIdentifier: "syrupsView")
//        } else{
//            return storyboard.instantiateViewController(withIdentifier: "speciesView")
//        }
//    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        OrderData.currSyrups = OrderData.tempSyrups
        OrderData.currSpecies = OrderData.tempSpecies
        OrderData.currAdditionals = OrderData.tempAdditionals
    }
}
