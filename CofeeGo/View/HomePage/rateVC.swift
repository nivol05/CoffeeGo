//
//  rateVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 11.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Tamamushi
import Cosmos

class rateVC: UIViewController {

    @IBOutlet weak var rateStar: CosmosView!
    @IBOutlet weak var BG2: UIView!
    @IBOutlet weak var mainBg: UIView!
    @IBOutlet weak var BG1: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var commentedElem : ElementComment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        isCommentedByUser()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func style(){
        cornerRatio(view: BG1, ratio: 5, shadow: false)
        cornerRatio(view: BG2, ratio: 5, shadow: false)
        cornerRatio(view: mainBg, ratio: 5, shadow: false)
        cornerRatio(view: confirmBtn, ratio: 5, shadow: false)
        cornerRatio(view: cancelBtn, ratio: 5, shadow: false)
    }
    @IBAction func confirmBtn(_ sender: Any) {
        if commentedElem == nil{
            if rateStar.rating != 0.0{
                // NEED COMPANY ID AND TODAYS DATE
                postNewComment(text: commentTextView.text, rate: rateStar.rating)
            } else {
                self.view.makeToast("Оценка обязаетельна")
            }
        } else {
            if commentedElem.comment != commentTextView.text
                || commentedElem.stars != rateStar.rating{
                
//                PageCoffee.UPDATE_PAGE = true
                postNewComment(text: commentTextView.text, rate: rateStar.rating)
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // CHANGED
    func postNewComment(text: String, rate: Double){
        var element = [String : Any]()
        element["user"] = current_coffee_user.id!
        element["stars"] = rate
        element["comment"] = text
        element["coffee_net"] = current_coffee_net.id!
        element["date"] = getCurrentDate()
        element["coffee_spot"] = current_coffee_spot.id!
        
        print("COMMENT \(element)")

        //        element["date"] = "" // TODAYS DATE
        
        postComment(commentRes: element).responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func setPrevious(){
        commentTextView.text = commentedElem.comment
        rateStar.rating = commentedElem.stars
    }
    
    func setEmpty(){
        commentTextView.text = ""
        rateStar.rating = 0.0
    }
    
    // CHANGED
    func isCommentedByUser(){
        // NEED USER ID AND COMPANY ID
        getUserCommentForNet(userId: "\(current_coffee_user.id!)", companyId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let userComments = value as! [[String : Any]]
                if userComments.count == 0{
                    
                } else {
                    self.commentedElem = ElementComment(mas: userComments[0])
                    self.setPrevious()
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
