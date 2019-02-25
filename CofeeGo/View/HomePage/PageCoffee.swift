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
import Toast_Swift
import NVActivityIndicatorView

class PageCoffee: UIViewController,  UICollectionViewDelegate , UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout,NVActivityIndicatorViewable{

    @IBOutlet weak var mapBtn: UIStackView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var btnMoreInfo: UIButton!
    
    @IBOutlet weak var cartPaymentImg: UIImageView!
    @IBOutlet weak var cashPaymentImg: UIImageView!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var instBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var allCommentsBtn: UIButton!
    
    @IBOutlet weak var rateLbl: UILabel!

    @IBOutlet weak var commentLbl: UILabel!
//    @IBOutlet weak var rearScrollView: UIScrollView!
    @IBOutlet weak var rateStarView: CosmosView!
    @IBOutlet weak var BGCommentEllement: UIView!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var stacView: UIStackView!
    @IBOutlet weak var imagePager: UIScrollView!
    @IBOutlet weak var titleLbl: UINavigationItem!
    @IBOutlet weak var metroLbl: UILabel!
    @IBOutlet weak var workTimeLbl: UILabel!
    @IBOutlet weak var metroLineImg: UIImageView!
    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var spotToMapBtn: UIButton!
    @IBOutlet weak var socialStackView: UIView!
    @IBOutlet weak var addCommentBtn: UIButton!
    
    @IBOutlet weak var cornerView: UIView!
    
    @IBOutlet weak var emptyView: UIView!
    
    var mText = true
    var comments = [ElementComment]()
    var users = [ElementUser]()
    var images : [[String: Any]] = [[String: Any]]()
    var menu = [ElementProduct]()
    var spotSocials = [[String: Any]]()
    var tabs : [Int]!
    
    var imageArray = [UIImage]()
    
    static var LoadViewActive = false
//    static var UPDATE_PAGE = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadContent()
    
//        emptyView.isHidden = true
        cornerRatio(view: cornerView, ratio: 10, shadow: false)
        cornerRatio(view: spotToMapBtn, ratio: 5, shadow: false)
        cornerRatio(view: mapBtn, ratio: 5, shadow: false)
        mapBtn.layer.masksToBounds = true
        scroll.delegate = self
        coffeeImg.clipsToBounds = true
        
        collection.dataSource = self
        collection.delegate = self
        cornerRatio(view: logoImg, ratio: 20, shadow: false)
         logoImg.layer.masksToBounds = true
        cornerView.clipsToBounds = false
        titleLbl.title = current_coffee_net.name_other
        
//        if header != nil{
//            addCommentBtn.isEnabled = true
//        } else {
//            addCommentBtn.isEnabled = false
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("tyta")
//        if PageCoffee.UPDATE_PAGE{
//            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
//            LoadContent()
//
//            PageCoffee.UPDATE_PAGE = false
//        }
        
        if PageCoffee.LoadViewActive{
            stopAnimating()
            loadingView.isHidden = true
        } else {
            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            loadingView.isHidden = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if comments.count > 5{ // CHANGED
            collection.isHidden = false
            return 5
        }
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        return CGSize(width: screenWidth - 20, height: screenHeight * 0.22)
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = self.scroll.contentOffset.y * 0.6
        let availableOffset = min(yOffset, coffeeImg.frame.height)
        let contentRectYOffset = availableOffset / coffeeImg.frame.size.height
        coffeeImg.layer.contentsRect = CGRect(x : 0.0,y : -contentRectYOffset,width: 1, height: 1)
        //        contentImageView.layer.contentsRect
    }
    
    func LoadContent(){
        
        // Setting payment method
        if current_coffee_spot.card_payment{
            paymentMethodLbl.text = "Оплата терминалом и наличными:"
            cartPaymentImg.isHidden = false
        } else{
            paymentMethodLbl.text = "Оплата только наличными:"
            cartPaymentImg.isHidden = true
        }
        
        // if spot is favorite
        if isFavorite(spotId: current_coffee_spot.id){
            setFavoriteBtn(fav: true)
        } else{
            setFavoriteBtn(fav: false)
        }
        
        streetLbl.text = current_coffee_spot.address
        nameLbl.text = current_coffee_net.name_other
        
        
        metroLbl.text = current_coffee_spot.metro_station
        workTimeLbl.text = "Время работы - \(current_coffee_spot.time_start!) - \(current_coffee_spot.time_finish!)"
        
        let descr = current_coffee_spot.description_full.replacingOccurrences(of: "spare", with: "")
        infoLbl.text = descr
        if descr == ""{
            btnMoreInfo.isHidden = true
        }
        
        Alamofire.request(current_coffee_net.logo_img).responseImage(completionHandler: {(response) in
            switch response.result {
            case .success(let value):
                self.logoImg.image = value
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        })
        
        Alamofire.request(current_coffee_spot.img).responseImage(completionHandler: {(response) in
            switch response.result {
            case .success(let value):
                self.coffeeImg.image = value
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        })
        
        getCommentsForNet(company: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.getFilledComments(comments: setElementCommentList(list: value as! [[String : Any]]))
                if self.comments.count == 0{
                    self.collection.isHidden = true
                    self.allCommentsBtn.isHidden = true
                    
                    self.emptyView.isHidden = false
                } else {
                    self.allCommentsBtn.isHidden = false
                    self.emptyView.isHidden = true
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
            
        }
        
        getPhotosForNet(companyId: "\(current_coffee_spot.id!)").responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                self.images = value as! [[String : Any]]
                if self.images.count > 0{
                    self.downloadPhotos(index: 0)
                } else{
                    self.imagePager.isHidden = true
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
        
        self.downloadSocials()
//        print("Images \(self.imageArray)")
    }
    
    func downloadPhotos(index : Int){
        if index == self.images.count{
            setPhotos()
        } else {
            let imageURL = "\(self.images[index]["img"]!)"
            Alamofire.request(imageURL).responseImage(completionHandler: {(response) in
                switch response.result {
                case .success(let value):
                    self.imageArray.append(value)
                    self.downloadPhotos(index: index + 1)
                    print("Images \(self.imageArray)")
                    break
                case .failure(let error):
                    self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                    self.stopAnimating()
                    print(error)
                    break
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
    
    
    // CHANGED
    func getCommentUsers(){
        getAllUsers().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.users = setElementUserList(list: value as! [[String : Any]])
                self.collection?.reloadData()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func isOrderInProcess(){
        getActiveUserOrders(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orders = value as! [[String : Any]]
                if orders.count == 0{
//                    self.loadingView.isHidden = false
                    self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)

                    self.downloadManuLists()
                    print("USER CAN ORDER")
                } else{
                    self.view.makeToast("У вас есть незавершенный заказ")
                    self.stopAnimating()
                    print("USER HAS ORDERS")
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
    
    func downloadSocials(){
        getSpotSocials(companyId: "\(current_coffee_spot.id!)").responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                self.spotSocials = value as! [[String: Any]]
                if self.spotSocials.count == 0{
                    self.socialStackView.isHidden = true
                } else{
                    self.setSocialBtns()
                }
                self.stopAnimating()
                self.loadingView.isHidden = true
                PageCoffee.LoadViewActive = true
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func downloadManuLists(){
        getProductsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.menu = setElementProductList(list: value as! [[String : Any]])
                self.setTabs()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func setTabs(){
        tabs = []
        
        for i in 0..<menu.count{
            var here = false
            let potom = self.menu[i].product_type
            for j in 0..<tabs.count{
                if potom == tabs[j]{
                    here = true
                    
                    break
                }
            }
            if !here{
                tabs.append(potom!)
            }
        }
        tabs.sort()
        print(tabs.count)
        goNext()
        
    }
    
    func setFavorite(){
        
        favoriteBtn.isEnabled = false
        var favoritePost: [String : Any] = [String : Any]()
            favoritePost["user"] = current_coffee_user?.id
            favoritePost["coffee_net"] = current_coffee_net?.id
            favoritePost["coffee_spot"] = current_coffee_spot?.id
        
        // set favorite
        setFavoriteBtn(fav: true)
        
        postFavorite(favoriteRes: favoritePost).responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                print("favorite \(value)")
                allFavorites.append(ElementFavorite(mas: value as! [String: Any]))
                userFavorites.append(getSpotPosition(spotId: current_coffee_spot.id))
                print(value)
                self.favoriteBtn.isEnabled = true
                break
                
            case .failure(let error):
                print(error)
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                // set not favorite back
                self.setFavoriteBtn(fav: false)
                self.favoriteBtn.isEnabled = true
                break
            }
        }
    }
    
    func delFavorite(){
        
        self.favoriteBtn.isEnabled = false
        // set not favorite
        setFavoriteBtn(fav: false)
        
        deleteFavoriteById(favoriteID: "\(allFavorites[getFavoritePosBySpot(spotId: current_coffee_spot.id!)].id!)").responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                allFavorites.remove(at: getFavoritePosBySpot(spotId: current_coffee_spot.id!))
                userFavorites.remove(at: getUserFavoritePos(spotPos: getSpotPosition(spotId: current_coffee_spot.id!)))
                print(value)
                self.favoriteBtn.isEnabled = true
                break
                
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                // set favorite back
                self.stopAnimating()
                self.setFavoriteBtn(fav: true)
                self.favoriteBtn.isEnabled = true
                break
            }
        }
    }
    
    func setFavoriteBtn(fav: Bool){
        if fav{
            favoriteBtn.setImage(UIImage(named: "like"), for: .normal)
        } else{
            favoriteBtn.setImage(UIImage(named: "like-2"), for: .normal)
        }
    }
    
    func setSocialBtns(){
        phoneBtn.isHidden = true
        instBtn.isHidden = true
        webBtn.isHidden = true
        facebookBtn.isHidden = true
        
        for x in spotSocials{
            switch x["social_network"] as! Int{
            case 2:
                phoneBtn.isHidden = false
                break
            case 3:
                instBtn.isHidden = false
                break
            case 4:
                facebookBtn.isHidden = false
                break
            case 5:
                webBtn.isHidden = false
                break
            default:
                print("nothing")
            }
        }
    }
    
    func getSocial(socialIndex: Int) -> [String : Any]?{
        for x in spotSocials{
            if x["social_network"] as! Int == socialIndex{
                return x
            }
        }
        return nil
    }
    
    func goNext(){
        
        if tabs.count != 0{
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cell = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
            
            cell.tabs = self.tabs
            
            //        let database = Database()
            //        database.deleteProduct()
            //        database.setProducts(products: menu)
            allSpotProducts = menu
            stopAnimating()
            PageCoffee.LoadViewActive = true
            self.navigationController?.pushViewController(cell, animated: true)
            //        loadingView.isHidden = true
        } else{
            stopAnimating()
            self.view.makeToast("У данной кофейни нету продуктов для заказа")
        }
    }
    
    @IBAction func webBtn(_ sender: Any) {
        let social = getSocial(socialIndex: 5)
        guard let url = URL(string: social?["value"] as! String)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func facebookBtn(_ sender: Any) {
        let social = getSocial(socialIndex: 4)
        guard let urlFacebook = URL(string: "fb://profile/\(social?["value"] as! String)")  else { return }
        guard let urlWebFb = URL(string: "https://facebook.com/\(social?["value"] as! String)")  else { return }
        if UIApplication.shared.canOpenURL(urlFacebook) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlFacebook, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urlWebFb)
            }
        }
    }
    
    @IBAction func instBtn(_ sender: Any) {
        let social = getSocial(socialIndex: 3)
        guard let url = URL(string: social?["value"] as! String)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func phoneBtn(_ sender: Any) {
        let social = getSocial(socialIndex: 2)
        //        guard let url = URL(string: "tel://\(social?["value"] as! String)")  else { return }
        //        if UIApplication.shared.canOpenURL(url) {
        //            if #available(iOS 10.0, *) {
        //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //            } else {
        //                UIApplication.shared.openURL(url)
        //            }
        //        }
        
        if let url = URL(string: "tel://\(social?["value"] as! String)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func moreInfo(_ sender: UIButton) {
        if self.mText{
            infoLbl.numberOfLines = 0
            self.btnMoreInfo.setTitle("Показать меньше ▲", for: UIControlState())
            self.mText = false
        } else {
            infoLbl.numberOfLines = 3
            self.btnMoreInfo.setTitle("Показать больше ▼", for: UIControlState())
            self.mText = true
        }
    }
    
    @IBAction func watchAllComments(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "allCommentsPage") as! AllCommentsVC
        
        cell.comments = self.comments
        cell.users = self.users
        
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    @IBAction func toOrderNext(_ sender: Any) {
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        if header != nil{
            isOrderInProcess()
        } else {
            self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            self.downloadManuLists()
        }
        
    }
    
    @IBAction func favoriteBtn(_ sender: Any) {
        if header != nil{
            if isFavorite(spotId: current_coffee_spot.id){
                delFavorite()
            } else{
                setFavorite()
            }
        } else {
            self.view.makeToast("Чтоб добавить в избранное нужно войти")
        }
        
    }
    
    // CHANGED
    func getFilledComments(comments: [ElementComment]){
        for x in comments{
            if x.comment != ""{
                self.comments.append(x)
            }
        }
        commentLbl.text = "Комментарии (\(self.comments.count))"
        
        rateLbl.text! = "\(current_coffee_spot.stars!) (\(comments.count))"
        rateStarView.rating = current_coffee_spot.stars
        if self.comments.count > 0{
            getCommentUsers()
        }
    }
    @IBAction func addCommentBtn(_ sender: Any) {
        if header != nil{
            performSegue(withIdentifier: "pressentRateVC", sender: self)
        } else {
            self.view.makeToast("Чтоб оставить комментарий нужно войти")
        }
        
    }
    
    @IBAction func mapBtn(_ sender: Any) {
        
    }
    
}
