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
        
        tabSwipe.setTabExtraWidth(UIScreen.main.bounds.size.width / 3)
//        tabSwipe.carbonSegmentedControl?.getWidthForSegment(at: 40)
        tabSwipe.setTabBarHeight(56)
//        tabSwipe.setTabExtraWidth(150)
//        tabSwipe.setSelectedColor(UIColor.black)
        tabSwipe.setIndicatorColor(UIColor.orange)
        tabSwipe.setIndicatorHeight(1)
        tabSwipe.setSelectedColor(UIColor.orange, font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.ultraLight))
        tabSwipe.insert(intoRootViewController: self, andTargetView: rootView)
        tabSwipe.setNormalColor(UIColor.lightGray)
        tabSwipe.setNormalColor(UIColor.gray, font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.ultraLight))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let color = UIColor(red: 1, green: 0.585, blue: 0, alpha: 100)
        UIApplication.shared.statusBarView?.backgroundColor = color
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "CoffeeList")
        } else {
            return storyboard.instantiateViewController(withIdentifier: "FavoritesList")
        }
        
    }
    @IBAction func loginBtn(_ sender: Any) {
        viewDidLoad()
    }

}
