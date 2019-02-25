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
import SwiftMessages

class ViewController: UIViewController ,UISearchBarDelegate, UITableViewDelegate , UITableViewDataSource,IndicatorInfoProvider{


//    @IBOutlet weak var searhBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var refreshStack: UIStackView!
    //    private var clusterManager: GMUClusterManager!
    
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var refresh : UIRefreshControl!
    var test = 0
    
    var name = String()

    var inSearchMode = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if Connectivity.isConnectedToInternet() {
            print(allCoffeeNets)
            refreshStack.isHidden = true
            print("Yes! internet is available.")
            refresh = UIRefreshControl()
            refresh.backgroundColor = UIColor.clear
            refresh.addTarget(self, action: #selector(ViewController.refreshPage), for: UIControlEvents.valueChanged)
//            refresh.
            tableView.addSubview(refresh)
            //Active tableView
            tableView.isHidden = false
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.reloadData()
            //Active searching
//            searhBar.delegate = self
//            searhBar.returnKeyType = UIReturnKeyType.done
            
            
        } else {
            refreshStack.isHidden = false
            print("nema")
        }

        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        PageCoffee.LoadViewActive = false
//    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : "Все")
    }
    
    //Table View

    //1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getActiveSpots().count
    }
    //2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cofeeCell" , for : indexPath) as? CofeeCell
        let spotElem = getActiveSpots()[indexPath.row]
        let coffeeElem = allCoffeeNets[getNetIndexBySpot(spot: spotElem)]
        
        
        var avatar_url: URL
        
        cell?.rateStars.rating = spotElem.stars
        cell?.addressLbl.text = spotElem.address
        cell?.metroLbl.text = spotElem.metro_station
        
        //              Download data for name lbl
        cell?.nameLbl?.text = coffeeElem.name_other
        //              Make Coffee image
        avatar_url = URL(string: spotElem.img)!
        cell?.CofeeImg.kf.setImage(with: avatar_url)
        
        //Download logo
        if coffeeElem.logo_img != ""{
            Alamofire.request(coffeeElem.logo_img).responseImage(completionHandler: {(response) in
                
                if let image = response.result.value{
                    let circularImage = image.af_imageRoundedIntoCircle()
                    DispatchQueue.main.async {
                        self.imageCache.setObject(circularImage, forKey: NSString(string : coffeeElem.logo_img))
                        cell?.previewImg.image = circularImage
                    }
                }
            })
        }
        return cell!
    }
    
    @objc func refreshPage(){
        self.getNets()
    }
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cofeeCell" , for : indexPath) as! CofeeCell
//        cell.CofeeImg.kf.cancelDownloadTask()
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PageCoffee.LoadViewActive = false
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "CommentPage") as! PageCoffee

        current_coffee_spot = getActiveSpots()[indexPath.row]
        current_coffee_net = allCoffeeNets[getNetIndexBySpot(spot: current_coffee_spot)]
        
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
    
    
    func getNets(){
        getCoffeeNets().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                allCoffeeNets = setElementCoffeeNetList(list: value as! [[String : Any]])
                self.spinner(shouldSpin: false)
                self.getSpots()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                self.refresh.endRefreshing()
                break
            }
        }
    }
    
    func getSpots(){
        getCoffeeSpots().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                allCoffeeSpots = setElementCoffeeSpotList(list: value as! [[String : Any]])
                self.tableView?.reloadData()
                self.refresh.endRefreshing()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                self.refresh.endRefreshing()
                break
            }

        }
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            refreshStack.isHidden = true
            print("Yes! internet is available.")
            refresh = UIRefreshControl()
            refresh.backgroundColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)
            refresh.addTarget(self, action: #selector(ViewController.refreshPage), for: UIControlEvents.valueChanged)
            //            refresh.
            tableView.addSubview(refresh)
            //Active tableView
            tableView.dataSource = self
            tableView.delegate = self
            //Active searching
            //            searhBar.delegate = self
            //            searhBar.returnKeyType = UIReturnKeyType.done
            
            //Loading Page bar
            //            spinner(shouldSpin: true)
            
            //Download coffeeList
            getNets()
        }
    }
}
