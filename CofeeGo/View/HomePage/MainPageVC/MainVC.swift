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
import SwiftMessages

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
        
        
//        let navigationController = navigationController,
//        let flareGradientImage = CAGradientLayer.primaryGradient(on: (navigationController?.navigationBar)!)
//        else {
//            print("Error creating gradient color!")
//            return
//        }
        
//        navigationController?.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage!)

//        navigationController?.navigationBar.applyNavigationGradient(colors: [UIColor.red , UIColor.yellow])
//        TabSwipe()
//        hidesBottomBarWhenPushed = false

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

//extension CAGradientLayer {
//
//    class func primaryGradient(on view: UIView) -> UIImage? {
//        let gradient = CAGradientLayer()
//        let flareRed = UIColor(displayP3Red: 241.0/255.0, green: 39.0/255.0, blue: 17.0/255.0, alpha: 1.0)
//        let flareOrange = UIColor(displayP3Red: 245.0/255.0, green: 175.0/255.0, blue: 25.0/255.0, alpha: 1.0)
//        var bounds = view.bounds
//        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
//        gradient.frame = bounds
//        gradient.colors = [flareRed.cgColor, flareOrange.cgColor]
//        gradient.startPoint = CGPoint(x: 1, y: 1)
//        gradient.endPoint = CGPoint(x: 1, y: 0)
//        return gradient.createGradientImage(on: view)
//    }
//
//    private func createGradientImage(on view: UIView) -> UIImage? {
//        var gradientImage: UIImage?
//        UIGraphicsBeginImageContext(view.frame.size)
//        if let context = UIGraphicsGetCurrentContext() {
//            render(in: context)
//            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
//        }
//        UIGraphicsEndImageContext()
//        return gradientImage
//    }
//}
