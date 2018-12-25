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
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pulseImg()
        
        refreshBtn.isHidden = true
        
        print("On")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let database = Database.init()
        if database.getUser() == nil{
            print("REg")
            performSegue(withIdentifier: "goToRegestration", sender: self)
        } else{
            print("log")
            current_coffee_user = database.getUser()
            login(completion: { (error) in})
        }
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
                self.downloadFavorites()
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
    
}
