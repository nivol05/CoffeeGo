//
//  CoffeeListVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import CarbonKit
import Tamamushi
import XLPagerTabStrip

class MainVC : ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        // change selected bar color
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
        
//        TabSwipe()


    }

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoffeeList")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesList")
        return [child_1, child_2]
    }

//    @IBAction func loginBtn(_ sender: Any) {
//        viewDidLoad()
//    }

}
