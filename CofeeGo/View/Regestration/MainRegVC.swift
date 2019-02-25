//
//  MainRegVC.swift
//  CofeeGo
//
//  Created by NI Vol on 12/12/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class MainRegVC: UIViewController {

    @IBOutlet weak var loginNoUser: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        cornerRatio(view: loginNoUser, ratio: 10, shadow: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func LoginNoUser(_ sender: Any) {
        header = nil
        
        
    
        performSegue(withIdentifier: "noUser", sender: self)
    }
    
}
