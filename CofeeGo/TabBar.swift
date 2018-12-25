//
//  TabBar.swift
//  CofeeGo
//
//  Created by NI Vol on 11/16/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isOrdered{
            self.selectedIndex = 1
        } else {
            self.selectedIndex = 0
        }
        
    }
//    @IBAction func goToSecond(sender: AnyObject) {
//        tabBarController?.selectedIndex = 1
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
