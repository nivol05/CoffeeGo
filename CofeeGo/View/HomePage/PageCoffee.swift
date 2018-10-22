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
    
    @IBOutlet weak var rateStarView: CosmosView!
    @IBOutlet weak var BGCommentEllement: UIView!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var stacView: UIStackView!
    @IBOutlet weak var imagePager: UIScrollView!
    
    var userCount = Int()
    var mText = true
    var comments : [[String: Any]] = [[String: Any]]()
    var descrip : String?
    var users : [[String: Any]] = [[String: Any]]()
    var images : [[String: Any]] = [[String: Any]]()
    static var coffeeId = String()
    
    var imageArray = [UIImage]()
    
//    var name = String()
    var imgUrl = String()
    var logo = String()
    
//    var test2 = Double()
    var st = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadContent()
        
        rateLbl.text = "\(st)"
        rateStarView.rating = st
        collection.dataSource = self
        collection.delegate = self
        cornerRatio(view: logoImg, ratio: 55, color: UIColor.orange.withAlphaComponent(1).cgColor, shadow: false)
        logoImg.layer.masksToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Comments", for: indexPath) as! CommentsCell
        
        if comments.count > 0{
            let commentList = comments[indexPath.row]
//            cornerRatio(view: cell.BGView)
            cell.BGView.layer.cornerRadius = 5
            cell.BGView.clipsToBounds = true
//            cell.corner()
            
            cell.commentLbl.text = (commentList["comment"] as? String) ?? ""
            
            //            if let stars = commentList["stars"] as? Double {
            //                cell?.rateInComment.rating = stars
            //            }
            
            cell.dateLbl?.text = (commentList["date"] as? String) ?? ""
            
            getAllUsers().responseJSON { (response) in
                if let responseValue = response.result.value{
                    self.users = responseValue as! [[String : Any]]
                    self.userCount = self.users.count
                    
                    for i in 0...self.userCount{
                        let user = self.users[i]
                        if user["id"] as? Int == commentList["user"] as? Int{
                            cell.userNameLbl.text = "\(String(describing: user["first_name"]!))  \(String(describing: user["last_name"]!))"
                            break
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func LoadContent(){
        
        nameLbl.text = User.name
        infoLbl.text = descrip
        
        Alamofire.request(logo).responseImage(completionHandler: {(response) in
            if let image = response.result.value{
                self.logoImg.image = image
            }
        })
        
        Alamofire.request(imgUrl).responseImage(completionHandler: {(response) in
            if let image = response.result.value{
                self.coffeeImg.image = image
            }
        })
        
        getCommentsForNet(company: User.name).responseJSON { (response) in
            
            if let responseValue = response.result.value{
                self.comments = responseValue as! [[String : Any]]
                print("HUI")
                self.collection?.reloadData()
            }
//            if self.comments.count == 0{
//                self.BGCommentEllement.isHidden = true
//            }
        }
        
        getPhotosForNet(companyId: PageCoffee.coffeeId).responseJSON{ (response) in
    
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
    
}
