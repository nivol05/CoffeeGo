//
//  ViewController.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.05.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import Kingfisher
import AlamofireImage
import SwiftyJSON
import SVProgressHUD
import Cosmos
import XLPagerTabStrip

class ViewController: UIViewController ,UISearchBarDelegate, UITableViewDelegate , UITableViewDataSource,IndicatorInfoProvider{


//    @IBOutlet weak var searhBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
//    private var clusterManager: GMUClusterManager!
    
    var CC : CofeeCell!
    var CT : CommentTable!
    var LC : ListCoffee!
    var CP : CoffeePage!
    var listCoff = [ListCoffee]()
    
    let imageCache = NSCache<NSString, UIImage>()
    var dataSource : Array<User>?
    
    var test = 0
    var coffee: [[String: Any]] = [[String: Any]]()

    var name = String()

    var inSearchMode = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet() {
            
            print("Yes! internet is available.")
            //Active tableView
            tableView.dataSource = self
            tableView.delegate = self
            //Active searching
//            searhBar.delegate = self
//            searhBar.returnKeyType = UIReturnKeyType.done
            
            //Loading Page bar
            spinner(shouldSpin: true)
            
            //Download coffeeList
            getCoffeeNets().responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                
                    self.coffee = value as! [[String : Any]]
                    self.downloadImage()
                    self.spinner(shouldSpin: false)
                    self.tableView?.reloadData()
                    
                    break
                case .failure(let error):
                    print(error)
                    break
                }
                
                
                
            }
            login(completion: { (error) in})
        } else {
            print("nema")
        }

        
        
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : "Все")
    }
    
    //Table View

    //1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffee.count
    }
    //2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cofeeCell" , for : indexPath) as? CofeeCell
            if coffee.count > 0 {
                let coffeeList = coffee[indexPath.row]
                var avatar_url: URL
                
                cell?.rateStars.rating = coffeeList["stars"] as! Double
                
//              Download data for name lbl
                cell?.nameLbl?.text = (coffeeList["name"] as? String) ?? ""
                
//              Make Coffee image
                avatar_url = URL(string: User.images[indexPath.row])!
                cell?.CofeeImg.kf.setImage(with: avatar_url)

                //Download logo
                if let logoImg = coffeeList["logo_img"] as? String{
                    Alamofire.request(logoImg).responseImage(completionHandler: {(response) in

                        if let image = response.result.value{
                            let circularImage = image.af_imageRoundedIntoCircle()
                            DispatchQueue.main.async {
                                self.imageCache.setObject(circularImage, forKey: NSString(string : logoImg))
                                cell?.previewImg.image = circularImage
                            }
                        }
                    })
                }
            }
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cofeeCell" , for : indexPath) as! CofeeCell
//        cell.CofeeImg.kf.cancelDownloadTask()
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "CommentPage") as! PageCoffee

        let coffeeList = coffee[indexPath.row]
        
        User.name = coffeeList["name"] as? String
        cell.imgUrl = coffeeList["img"] as! String
        cell.logo = coffeeList["logo_img"] as! String
        cell.descrip = coffeeList["description_full"] as? String
        cell.st = coffeeList["stars"] as! Double
        PageCoffee.coffeeId = "\(coffeeList["id"]!)"
        
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        self.tableView.isHidden = true
//        spinner(shouldSpin: true)
//        
//        if searchBar.text == nil || searchBar.text == ""{
//            inSearchMode = false
//            
//            Alamofire.request(LIST_COFFEE_URL).responseJSON { (response) in
//                if let responseValue = response.result.value{
//                    self.coffee = responseValue as! [[String : Any]]
//                    self.spinner(shouldSpin: false)
//                    self.tableView?.reloadData()
//
//                }
//            }
//            
//        } else {
//            
//            Alamofire.request("http://138.68.79.98/api/customers/coffee_nets/?search=\(searchBar.text!)").responseJSON { (response) in
//                
//                if let responseValue = response.result.value{
//                    self.coffee = responseValue as! [[String : Any]]
//                    self.spinner(shouldSpin: false)
//                    self.tableView?.reloadData()
//                }
//            }
//        }
//        view.endEditing(true)
//    }
    
    func spinner(shouldSpin status: Bool){
        if status == true{
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
            self.tableView.isHidden = false


        }
    }
    
    func downloadImage(){
        for i in 0..<coffee.count{
            var index = coffee[i]
            if let test = index["img"] as? String{
                User.images.append(test)
            }
        }
        
    }
    
     func login(completion: @escaping (_ error: NSError?) -> Void) {
        
        getToken(username: "retrofit", pass: "111111111").responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                token = "Token \(jsonData["token"].string!)"
                header = [
                    "Authorization": token
                ]
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        login(completion: { (error) in})
    }
}
