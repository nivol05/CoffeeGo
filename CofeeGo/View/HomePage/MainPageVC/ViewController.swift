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

class ViewController: UIViewController ,UISearchBarDelegate, UITableViewDelegate , UITableViewDataSource{


    @IBOutlet weak var searhBar: UISearchBar!
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
    var token = String()
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
            searhBar.delegate = self
            searhBar.returnKeyType = UIReturnKeyType.done
            
            //Loading Page bar
            spinner(shouldSpin: true)
            
            //Download coffeeList
            Alamofire.request(LIST_COFFEE_URL).responseJSON { (response) in
                
                if let responseValue = response.result.value{
                    self.coffee = responseValue as! [[String : Any]]
                    self.downloadImage()
                    self.spinner(shouldSpin: false)
                    self.tableView?.reloadData()
                }
                
            }
            login(completion: { (error) in})
        } else {
            print("nema")
        
        }

        
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "CommentPage") as! CoffeePage

        let coffeeList = coffee[indexPath.row]
        
        cell.name = coffeeList["name"] as! String
        User.name = coffeeList["name"] as! String
        cell.imgUrl = coffeeList["img"] as! String
        cell.logo = coffeeList["logo_img"] as! String
//        let stars = coffeeList["stars"] as! Double
//        print(stars)
        cell.st = coffeeList["stars"] as! Double
        cell.token = token
        
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.tableView.isHidden = true
        spinner(shouldSpin: true)
        
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            
            Alamofire.request(LIST_COFFEE_URL).responseJSON { (response) in
                if let responseValue = response.result.value{
                    self.coffee = responseValue as! [[String : Any]]
                    self.spinner(shouldSpin: false)
                    self.tableView?.reloadData()

                }
            }
            
        } else {
            
            Alamofire.request("http://138.68.79.98/api/customers/coffee_nets/?search=\(searchBar.text!)").responseJSON { (response) in
                
                if let responseValue = response.result.value{
                    self.coffee = responseValue as! [[String : Any]]
                    self.spinner(shouldSpin: false)
                    self.tableView?.reloadData()
                }
            }
        }
        view.endEditing(true)
    }
    
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
        
        let path = "/api/customers/api-token-auth/"
        let url = "\(BASE_URL)\(path)"
        let params: [String: Any] = [
            "username": "retrofit",
            "password": "111111111"
        ]
        
        
        Alamofire.request(url, method: .post , parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                self.token = "Token \(jsonData["token"].string!)"
                
                print(self.token)
                break
                
            case .failure(let error):
                completion(error as NSError)
                break
            }
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        login(completion: { (error) in})
    }
}
