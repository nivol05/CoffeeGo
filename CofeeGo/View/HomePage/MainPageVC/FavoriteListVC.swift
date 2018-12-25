//
//  FavoriteListVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 19.07.2018.
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

class FavoriteListVC: UIViewController ,IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let imageCache = NSCache<NSString, UIImage>()

    @IBOutlet weak var emptyView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet() {
            
            print("Yes! internet is available.")
            //            refresh.
            //Active tableView
            tableView.dataSource = self
            tableView.delegate = self
            
            
            //Active searching
            //            searhBar.delegate = self
            //            searhBar.returnKeyType = UIReturnKeyType.done
            
            //Loading Page bar
            //            spinner(shouldSpin: true)
            
            //Download coffeeList
            
        } else {
            print("nema")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if userFavorites.count == 0{
            emptyView.isHidden = false
        }  else {
            emptyView.isHidden = true
        }
        return userFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell" , for : indexPath) as! FavoriteListCell
        
        
        let spotElem = allCoffeeSpots[userFavorites[indexPath.row]]
        let coffeeElem = allCoffeeNets[getNetIndexBySpot(spot: spotElem)]
        
        var avatar_url: URL
        
        cell.rateStars.rating = spotElem.stars
        cell.addressLbl.text = spotElem.address
        cell.metroLbl.text = spotElem.metro_station
        
        //              Download data for name lbl
        cell.nameLbl?.text = coffeeElem.name_other
        
        //              Make Coffee image
        avatar_url = URL(string: spotElem.img)!
        cell.coffeeImg.kf.setImage(with: avatar_url)
        
        //Download logo
        if coffeeElem.logo_img != ""{
            avatar_url = URL(string: coffeeElem.logo_img)!
            cornerRatio(view: cell.logoImg, ratio: cell.logoImg.frame.height/2 , shadow: false)
            cell.logoImg.kf.setImage(with: avatar_url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PageCoffee.LoadViewActive = false
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "CommentPage") as! PageCoffee
        
        current_coffee_spot = allCoffeeSpots[userFavorites[indexPath.row]]
        current_coffee_net = allCoffeeNets[getNetIndexBySpot(spot: current_coffee_spot)]
        
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : "Любимые")
    }
    
    @objc func refreshPage(){
        getFavoritesForUser(userId: "\(current_coffee_user.id!)").responseJSON{ (response) in
            
            switch response.result {
            case .success(let value):
                allFavorites = setElementFavoriteList(list: value as! [[String : Any]])
                for x in allFavorites{
                    let pos = getSpotPosition(spotId: x.coffee_spot)
                    if pos != -1 && allCoffeeSpots[pos].is_active{
                        userFavorites.append(pos)
                    }
                }
                
                // set all
                self.tableView.reloadData()
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
        
    }

    
    
}
