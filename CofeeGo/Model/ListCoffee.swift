

import UIKit
import Alamofire
import Kingfisher

class ListCoffee{
    
    var CC : CofeeCell!
    var VC : ViewController!
    
    var _name : String!
    var _logo : String!
    var _caffeeImg : String!
    var coffee : [[String : Any]] = [[String : Any]]()
    
    
    var name : String{
        if _name == nil{
            _name = ""
        }
        return _name
    }
    
    var caffeeImg : String{
        if _caffeeImg == nil{
            _caffeeImg = ""
        }
        
        return _caffeeImg
    }
}

