//
//  rateVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 11.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Tamamushi

class rateVC: UIViewController {

    @IBOutlet weak var BG2: UIView!
    @IBOutlet weak var mainBg: UIView!
    @IBOutlet weak var BG1: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    func style(){
        BG2.layer.cornerRadius = 12
        BG2.clipsToBounds = true
        mainBg.layer.cornerRadius = 12
        BG1.layer.cornerRadius = 12
        BG2.layer.masksToBounds = false
    }
    @IBAction func confirmBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
