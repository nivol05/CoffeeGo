//
//  FirstLoadingVC.swift
//  CofeeGo
//
//  Created by NI Vol on 11/28/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseMessaging

class FirstLoadingVC: UIViewController {

    let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
    
    @IBOutlet weak var updateWindow: UIView!
    @IBOutlet weak var updateWindowBG: UIView!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refreshBtn.isHidden = true
        
        print("On")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        getversion()
        
        cornerRatio(view: updateBtn, ratio: 5, shadow: false)
        cornerRatio(view: updateWindowBG, ratio: 5, shadow: false)
        
        needsUpdate()
        
    }
    
    func getversion(){
        Alamofire.request("http://itunes.apple.com/lookup?bundleId=com.CoffeeGo.CoffeeGo",method: .get ,parameters: nil).responseJSON{ (response) in
            switch response.result {
                
            case .success(let value):
                let app = value as! [String: Any]
                if let results = app["results"] as? [[String:Any]] {
                    let ver = results[0]["version"] as? String
                    print("Version loh \(ver!)")
                }
                
                
                
                
                break
            case .failure(let error):
                print(error)
                break
            }
    }
    
    
    //        if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
    //            if let results = lookup!["results"] as? [[String:Any]] {
    //                if let appStoreVersion = results[0]["version"] as? String{
    //                    print("Version App store \(appStoreVersion)")
    //                }
    //            }
    //        }
    }
    
    func needsUpdate() -> Bool {
        let infoDictionary = Bundle.main.infoDictionary
        let appID = infoDictionary!["CFBundleIdentifier"] as! String
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)")
        
        print("Version \(url!)")
        
        guard let data = try? Data(contentsOf: url!) else {
            self.refreshBtn.isHidden = false
            self.scaleAnimation.repeatCount = 0
            self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
            return false;
        }
        let lookup = (try? JSONSerialization.jsonObject(with: data , options: [])) as? [String: Any]
        if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
            if let results = lookup!["results"] as? [[String:Any]] {
                if let appStoreVersion = results[0]["version"] as? String{
                    let currentVersion = infoDictionary!["CFBundleShortVersionString"] as? String
                    print("Version curr \(currentVersion!)")
                    print("Version App store \(appStoreVersion)")
                    if !(appStoreVersion == currentVersion) {
                        
                        self.updateWindow.isHidden = true
                        
                        pulseImg()
                        
                        userFavorites.removeAll()
                        
                        let database = Database.init()
                        if database.getUser() == nil{
                            print("REg")
                            if header != nil{
                                performSegue(withIdentifier: "goToRegestration", sender: self)
                            }
                            
                        } else{
                            print("log")
                            current_coffee_user = database.getUser()
                            login(completion: { (error) in})
                        }
                        
                        if header == nil{
                            getNets()
                            
                        }

//                        self.updateWindow.isHidden = false
                        
                        return true
                    } else {
                        self.updateWindow.isHidden = true
                        
                        pulseImg()
                        
                        userFavorites.removeAll()
                        
                        let database = Database.init()
                        if database.getUser() == nil{
                            print("REg")
                            if header != nil{
                                performSegue(withIdentifier: "goToRegestration", sender: self)
                            }
                            
                        } else{
                            print("log")
                            current_coffee_user = database.getUser()
                            login(completion: { (error) in})
                        }
                        
                        if header == nil{
                            getNets()
                            
                        }
                        
                        
                        
                    }
                }
            }
        }
        
        
        return false
    }
    
    func pulseImg(){
        scaleAnimation.duration = 0.8
        scaleAnimation.repeatCount = 100
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1.0;
        scaleAnimation.toValue = 1.2;
        self.logoImg.layer.add(scaleAnimation, forKey: "scale")
    }
    
    func getNets(){
        getCoffeeNets().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                allCoffeeNets = setElementCoffeeNetList(list: value as! [[String : Any]])
                self.getSpots()
                break
            case .failure(let error):
                self.refreshBtn.isHidden = false
                
                self.scaleAnimation.repeatCount = 0

                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func getSpots(){
        getCoffeeSpots().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                allCoffeeSpots = setElementCoffeeSpotList(list: value as! [[String : Any]])
                
    
                if header != nil{
                    self.downloadFavorites()
                } else {
                    
                    print("Pidor2")
                    self.performSegue(withIdentifier: "OpenMainView", sender: self)
                    
                }
                
                break
            case .failure(let error):
                self.refreshBtn.isHidden = false
                 self.scaleAnimation.repeatCount = 0
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
            
        }
    }
    
    
    func login(completion: @escaping (_ error: NSError?) -> Void) {

        getToken(username: current_coffee_user.username,
                 pass: current_coffee_user.password).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                let token = "Token \(jsonData["token"].string!)"
                header = [
                    "Authorization": token
                ]
                self.getNets()
                break
            case .failure(let error):
                self.refreshBtn.isHidden = false
                self.scaleAnimation.repeatCount = 0
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func downloadFavorites(){
        getFavoritesForUser(userId: "\(current_coffee_user.id!)").responseJSON{ (response) in
            
            switch response.result {
            case .success(let value):
                allFavorites = setElementFavoriteList(list: value as! [[String : Any]])
                for x in allFavorites{
                    let pos = getSpotPosition(spotId: x.coffee_spot)
                    if pos != -1 && allCoffeeSpots[pos].is_active{
                        userFavorites.append(pos)
                    }
                }
                
                // set all
                self.loadFinished()
                print("Ã")
                break
                
            case .failure(let error):
                self.refreshBtn.isHidden = false
                self.scaleAnimation.repeatCount = 0
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func loadFinished(){
        performSegue(withIdentifier: "OpenMainView", sender: self)
    }
    
    
    @IBAction func refreshBtn(_ sender: Any) {
        login(completion: { (error) in})
        refreshBtn.isHidden = true
        scaleAnimation.repeatCount = 100
        self.logoImg.layer.add(scaleAnimation, forKey: "scale")


    }
    @IBAction func updateBtn(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/ua/app/coffeego/id1445775253?mt=8")! as URL)
    }
    
}
