//
//  loginVC.swift
//  CofeeGo
//
//  Created by NI Vol on 12/11/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseMessaging
import NVActivityIndicatorView

class LoginVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var BGView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    var user: ElementUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }

    func style(){
        cornerRatio(view: BGView, ratio: 12, shadow: true)
    }
    
    func getToketValue(completion: @escaping (_ error: NSError?) -> Void) {
        
        getToken(username: emailTF.text!, pass: passTF.text!).responseJSON { (response) in
            
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
                    print(value)
                    self.view.makeToast("Електронная почта или пароль введены неправильно")
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
    
    func checkBarista(){
        CofeeGo.checkBarista(username: emailTF.text!).responseJSON { (response) in
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
    
    func getUser(){
        CofeeGo.getUser(username: emailTF.text!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.user = ElementUser(mas: (value as! [[String : Any]])[0])
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
        CofeeGo.postFcmDevice(name: self.user.first_name,
                              userId: self.user.id!,
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
        
        self.finishSignIn()
    }
    
    func finishSignIn(){
        self.stopAnimating()
        performSegue(withIdentifier: "loginToFirstVC", sender: self)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        getToketValue(completion: { (error) in})
    }
}
