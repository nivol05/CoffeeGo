//
//  Test.swift
//  CofeeGo
//
//  Created by NI Vol on 10/3/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos

class PageCoffee: UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource{

    @IBOutlet weak var infoLbl: UILabel!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var rateLbl: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var rateStarView: CosmosView!
    @IBOutlet weak var BGCommentEllement: UIView!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var stacView: UIStackView!
    @IBOutlet weak var imagePager: UIScrollView!
    
    var mText = true
    var comments = [ElementComment]()
    var users = [ElementUser]()
    var images : [[String: Any]] = [[String: Any]]()
    var allRates : Int = 0 // CHANGED
    
    var imageArray = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadContent()
        
        rateLbl.text! = "\(current_coffee_net.stars!)"
        rateStarView.rating = current_coffee_net.stars
        collection.dataSource = self
        collection.delegate = self
        cornerRatio(view: logoImg, ratio: 55, shadow: false)
        logoImg.layer.masksToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if comments.count > 5{ // CHANGED
            return 5
        }
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Comments", for: indexPath) as! CommentsCell
        
        if comments.count > 0{
            let commentElem = comments[indexPath.row]
//            cornerRatio(view: cell.BGView)
            cell.BGView.layer.cornerRadius = 5
            cell.BGView.clipsToBounds = true
//            cell.corner()
            
            cell.commentLbl.text = commentElem.comment
            cell.rateInComments.rating = commentElem.stars
            
            //            if let stars = commentList["stars"] as? Double {
            //                cell?.rateInComment.rating = stars
            //            }
            
            cell.dateLbl?.text = commentElem.date
            
            for i in 0..<self.users.count{
                let user = self.users[i]
                if user.id == commentElem.user{
                    cell.userNameLbl.text = "\(user.first_name!)"
                    break
                }
            }
        }
        return cell
    }
    
    func LoadContent(){
        
        nameLbl.text = current_coffee_net.name_other
        infoLbl.text = current_coffee_net.description_full
        
        Alamofire.request(current_coffee_net.logo_img).responseImage(completionHandler: {(response) in
            if let image = response.result.value{
                self.logoImg.image = image
            }
        })
        
        Alamofire.request(current_coffee_net.img).responseImage(completionHandler: {(response) in
            if let image = response.result.value{
                self.coffeeImg.image = image
            }
        })
        
        getCommentsForNet(company: current_coffee_net.name).responseJSON { (response) in
            
            if let responseValue = response.result.value{
                self.getFilledComments(comments: setElementCommentList(list: responseValue as! [[String : Any]]))
              
            }
//            if self.comments.count == 0{
//                self.BGCommentEllement.isHidden = true
//            }
        }
        
        getPhotosForNet(companyId: "\(current_coffee_net.id!)").responseJSON{ (response) in
    
            if let responseValue = response.result.value{
                self.images = responseValue as! [[String : Any]]
                
                if self.images.count > 0{
                    self.downloadPhotos(index: 0)
                }
                
            }
        }
//        print("Images \(self.imageArray)")
    }
    
    func downloadPhotos(index : Int){
        if index == self.images.count{
            setPhotos()
        } else {
            let imageURL = "\(self.images[index]["img"]!)"
            Alamofire.request(imageURL).responseImage(completionHandler: {(response) in
                if let image = response.result.value{
                    
                    self.imageArray.append(image)
                    self.downloadPhotos(index: index + 1)
                    print("Images \(self.imageArray)")
                }
            })
        }
        
    }
    
    func setPhotos(){
        for i in 0..<self.imageArray.count{
            
            let imageView = UIImageView()
            imageView.image = self.imageArray[i]
            imageView.contentMode = .scaleAspectFill
            let xPosition = self.view.frame.width * CGFloat(i)
            
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.imagePager.frame.width, height: self.imagePager.frame.height)
            
            self.imagePager.contentSize.width = self.imagePager.frame.width * CGFloat(i + 1)
            self.imagePager.addSubview(imageView)
        }
    }
    
    @IBAction func moreTextBtn(_ sender: Any) {
        if self.mText{
            infoLbl.numberOfLines = 0
            
            self.mText = false
        } else {
            infoLbl.numberOfLines = 3
            
            self.mText = true
        }

    }
    
    @IBAction func addNewComment(_ sender: Any) {
        
    }
    
    @IBAction func watchAllComments(_ sender: Any) {
        isOrderInProcess()
    }
    
    
    
    // CHANGED
    func getFilledComments(comments: [ElementComment]){
        for x in comments{
            if x.comment != ""{
                self.comments.append(x)
            }
        }
        self.allRates = comments.count
        commentLbl.text = "Комментарии (\(self.comments.count))"
        if self.comments.count > 0{
            getCommentUsers()
        }
    }
    
    // CHANGED
    func getCommentUsers(){
        getAllUsers().responseJSON { (response) in
            if let responseValue = response.result.value{
                self.users = setElementUserList(list: responseValue as! [[String : Any]])
                self.collection?.reloadData()
            }
        }
    }
    
    // CHANGED
    func isCommentedByUser(){
        // NEED USER ID AND COMPANY ID
        getUserCommentForNet(userId: "\(current_coffee_user.id!)", companyId: "\(current_coffee_net.id!)").responseJSON { (response) in
            if let responseValue = response.result.value{
                let userComments = responseValue as! [[String : Any]]
                if userComments.count == 0{
                    // make new comment
                } else {
                    // change previous comment
                }
            }
        }
    }
    
    func isOrderInProcess(){
        getActiveUserOrders(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            if let responseValue = response.result.value{
                let orders = responseValue as! [[String : Any]]
                if orders.count == 0{
                    // make new comment
                    print("USER CAN ORDER")
                } else{
                    print("USER HAS ORDERS")
                }
            }
        }
    }
}
