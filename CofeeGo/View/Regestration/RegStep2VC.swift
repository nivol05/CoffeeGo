//
//  RegStep2VC.swift
//  CofeeGo
//
//  Created by NI Vol on 12/12/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class RegStep2VC: UIViewController {

    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var emailTF: UITextField!

    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRatio(view: BG, ratio: 12, shadow: true)
        // Do any additional setup after loading the view.
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let res = emailTest.evaluate(with: email)
        if res{
            return true
        } else{
            self.view.makeToast("Почта введена неправильно")
            return false
        }
    }

    func toNext(){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "RegStep3") as! RegStep3VC
        cell.name = name
        cell.email = emailTF.text
        
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    @IBAction func toNextStep(_ sender: Any) {
        if isValidEmail(email: emailTF.text!){
            toNext()
        }
    }
}
