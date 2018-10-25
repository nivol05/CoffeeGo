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
    
    var commentedElem : ElementComment!
    var coffeeNetId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        if commentedElem.date != nil{
            setPrevious()
        }
    }
    
    func style(){
        BG2.layer.cornerRadius = 12
        BG2.clipsToBounds = true
        mainBg.layer.cornerRadius = 12
        BG1.layer.cornerRadius = 12
        BG2.layer.masksToBounds = false
    }
    @IBAction func confirmBtn(_ sender: Any) {
        if commentedElem.date != nil{
            if rateStar.rating != 0.0{
                // NEED COMPANY ID AND TODAYS DATE
                postNewComment(text: commentTextView.text, rate: rateStar.rating, coffeeNetId: coffeeNetId)
            } else {
                print("CANT BE 0 SUKA")
            }
        } else {
            if commentedElem.comment != commentTextView.text
                || commentedElem.stars != rateStar.rating{
                deletePrevComment()
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // CHANGED
    func postNewComment(text: String, rate: Double, coffeeNetId : Int){
        var element = [String : Any]()
        element["stars"] = rate
        element["comment"] = text
        element["coffee_net"] = coffeeNetId
        //        element["date"] = "" // TODAYS DATE
        
        postComment(commentRes: element).responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                print("Good \(value)")
                self.dismiss(animated: true, completion: nil)
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func deletePrevComment(){
        deleteCommentById(commentId: "\(commentedElem.id!)").responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                print("Good \(value)")
                self.postNewComment(text: self.commentTextView.text,
                                    rate: self.rateStar.rating,
                                    coffeeNetId: self.commentedElem.coffee_net)
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func setPrevious(){
        commentTextView.text = commentedElem.comment
        rateStar.rating = commentedElem.stars
    }
}
