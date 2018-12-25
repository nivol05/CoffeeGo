//
//  RegStep3VC.swift
//  CofeeGo
//
//  Created by NI Vol on 12/12/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseMessaging
import NVActivityIndicatorView


class RegStep3VC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var BG: UIView!
    
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var confPassTF: UITextField!
    
    var name: String!
    var email: String!
    var user: ElementUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRatio(view: BG, ratio: 12, shadow: true)
        // Do any additional setup after loading the view.
    }
    
    func hasLetters(pass: String) -> Bool{
        let letters = NSCharacterSet.letters
        
        let range = pass.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if let test = range {
            print(test)
            print("letters found")
            return true
        }
        else {
            print("letters not found")
            return false
        }
    }
    
    func isValidPass(pass: String) -> Bool{
        if pass.count >= 6 && hasLetters(pass: pass){
            return true
        } else{
            self.view.makeToast("Пароль должен содержать миннимум 6 символов и хотя бы одну букву")
            return false
        }
    }
    
    func isMatching(pass: String, conf: String) -> Bool{
        let res = pass == conf
        if res{
            return true
        } else{
            self.view.makeToast("Пароли не совпадают")
            return false
        }
    }
    
    func getToketValue(completion: @escaping (_ error: NSError?) -> Void) {
        
        getToken(username: email, pass: passTF.text!).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                if jsonData["token"] != JSON.null{
                    let token = "Token \(jsonData["token"].string!)"
                        header = [
                            "Authorization": token
                        ]
                    self.checkBarista()
                } else {
                    self.registerUser()
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func checkBarista(){
        CofeeGo.checkBarista(username: email).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if (value as! [[String : Any]]).count == 0{
                    self.getUser()
                } else{
                    self.view.makeToast("Нельзя входить с аккаунта бариста")
                    self.stopAnimating()
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func registerUser(){
        
        CofeeGo.registerUser(username: email, pass: passTF.text!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.getToketValue(completion: { (error) in})
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getUser(){
        CofeeGo.getUser(username: email).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.user = ElementUser(mas: (value as! [[String : Any]])[0])
                self.user.first_name = self.name
                self.user.password = self.passTF.text!
                self.postFcmDevice()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func postFcmDevice(){
        CofeeGo.postFcmDevice(name: name,
                              userId: user.id!,
                              fcmToken: Messaging.messaging().fcmToken!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.saveUser()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func saveUser(){
        let database = Database.init()
        database.setUser(user: self.user)
        
        self.finishReg()
    }
    
    func finishReg(){
        self.stopAnimating()
        performSegue(withIdentifier: "FirstLoading", sender: nil)
    }
    
    @IBAction func compleateRegestration(_ sender: Any) {
        
        if isValidPass(pass: passTF.text!)
            && isMatching(pass: passTF.text!, conf: confPassTF.text!){
            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
//            finishReg()
            getToketValue(completion: { (error) in})
        }
    }
    
}
