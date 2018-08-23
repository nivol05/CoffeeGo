//
//  rateVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 11.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class rateVC: UIViewController {

    @IBOutlet weak var BGImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = BGImage.bounds
        BGImage.addSubview(blurView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
