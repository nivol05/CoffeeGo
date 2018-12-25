//
//  RegStep1VC.swift
//  CofeeGo
//
//  Created by NI Vol on 12/12/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Toast_Swift

class RegStep1VC: UIViewController {
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRatio(view: BG, ratio: 12, shadow: true)
        
    }
    
    func notEmpty(name: String) -> Bool{
        let res = name.count != 0
        if res{
            return true
        } else{
            self.view.makeToast("Имя не может быть пустым")
            return false
        }
    }
    
    func toNext(){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "RegStep2") as! RegStep2VC
        cell.name = nameTF.text
        
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    @IBAction func toNextStep(_ sender: Any) {
        if notEmpty(name: nameTF.text!){
            toNext()
        }
    }
    
}
