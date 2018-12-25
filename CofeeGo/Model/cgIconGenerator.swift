//
//  cgIconGenerator.swift
//  CofeeGo
//
//  Created by NI Vol on 11/17/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class cgIconGenerator: NSObject, GMUClusterIconGenerator {
    
    func icon(forSize size: UInt) -> UIImage! {
        return UIImage(named: "map_marker")!.withRenderingMode(.alwaysTemplate)
    }
    
    
}
