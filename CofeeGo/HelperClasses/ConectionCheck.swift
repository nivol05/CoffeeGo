//
//  ConectionCheck.swift
//  CofeeGo
//
//  Created by Ni VoL on 30.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
