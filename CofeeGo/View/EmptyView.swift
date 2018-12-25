//
//  EmptyView.swift
//  CofeeGo
//
//  Created by NI Vol on 11/21/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet var bg: UIView!
    @IBOutlet weak var Lbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commitInit(){
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        
        addSubview(bg)
        bg.frame = self.bounds
        bg.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }
}
