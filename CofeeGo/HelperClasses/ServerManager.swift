//
//  ServerManager.swift
//  CofeeGo
//
//  Created by Ni VoL on 05.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import MapKit

class ServerManager{
    
    
//    class func getCoffeeList(url: String, completion: @escaping (_ error: NSError?, _ user: [User]?) -> Void){
//        Alamofire.request(url).responseJSON { (response) in
//            if response.response?.statusCode == 200{
//                if let data = response.result.value as? [[String: Any]]{
////                  self.coffee = responseValue as! [[String : Any]]
//                    var arr = Array<User>()
//                    for item in data{
//                        let user = User()
//                        user.logo = (item["logo_img"] as? String)
//                        arr.append(user)
//                    }
//                    completion(nil, arr)
//                } else {
//                    completion(nil, [])
//                }
//            } else {
//                let err = NSError(domain:"", code:(response.response?.statusCode)!, userInfo:nil)
//                completion(err, nil)
//            }
//        }
//    }
}
