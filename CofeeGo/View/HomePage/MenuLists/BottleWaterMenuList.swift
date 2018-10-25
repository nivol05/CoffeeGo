//
//  BottleWaterMenuList.swift
//  CofeeGo
//
//  Created by Ni VoL on 16.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BottleWaterMenuList: UIViewController  , UITableViewDataSource,UITableViewDelegate, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "Drinks"))
    }
    @IBOutlet weak var tableView: UITableView!
    var products : [ElementProduct]!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let database = Database()
        products = getProductsByType(type: 9)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = products[indexPath.row]
        var avatar_url: URL
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottleManu" , for : indexPath) as? BottleManu
        
        cell?.productElem = data
        //Name
        cell?.nameLbl.text = data.name
        
        //CoffeeImage
        avatar_url = URL(string: data.img)!
        cell?.CoffeeImg.kf.setImage(with: avatar_url)
        
        //Price
        var price_text = ""
        
        let price = data.price
        price_text += "\(price!) grn"
        
        cell?.priceLbl.text = price_text
        
        return cell!
    }

}
