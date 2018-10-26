//
//  Extensions.swift
//  CofeeGo
//
//  Created by NI Vol on 10/26/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

extension Double {
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
