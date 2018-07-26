//
//  infoWindow.swift
//  CofeeGo
//
//  Created by Ni VoL on 26.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class infoWindow: UIView {
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    
    
    @IBAction func didTapInButton(_ sender: Any) {
        print("button tapped")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "infoWindows", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }

}
