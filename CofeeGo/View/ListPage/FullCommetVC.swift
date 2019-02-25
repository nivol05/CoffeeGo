//
//  FullCommetVC.swift
//  CofeeGo
//
//  Created by NI Vol on 2/13/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class FullCommetVC: UIViewController {

    @IBOutlet weak var userCommentTV: UITextView!
    @IBOutlet weak var baristaCommentTV: UITextView!
    var userComment : String!
    var baristaComment : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCommentTV.text = userComment
        baristaCommentTV.text = baristaComment
        
        cornerRatio(view: userCommentTV, ratio: 5, shadow: false)
        cornerRatio(view: baristaCommentTV, ratio: 5, shadow: false)
        
    }

}
