//
//  CoffeeListVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import CarbonKit

class MainVC : UIViewController , CarbonTabSwipeNavigationDelegate {

    @IBOutlet weak var rootView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabSwipe = CarbonTabSwipeNavigation(items: ["  Все  ","Любимые"] , delegate: self)
        
        tabSwipe.setTabExtraWidth(UIScreen.main.bounds.size.width / 4)
//        tabSwipe.carbonSegmentedControl?.getWidthForSegment(at: 40)
        tabSwipe.setTabBarHeight(56)
        tabSwipe.setSelectedColor(UIColor.black)
        tabSwipe.setIndicatorColor(UIColor.orange)
        tabSwipe.insert(intoRootViewController: self, andTargetView: rootView)
        tabSwipe.setNormalColor(UIColor.lightGray)
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "CoffeeList")
        } else {
            return storyboard.instantiateViewController(withIdentifier: "FavoritesList")
        }
        
    }

}
