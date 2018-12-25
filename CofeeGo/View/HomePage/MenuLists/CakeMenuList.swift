//
//  CakeMenuList.swift
//  CofeeGo
//
//  Created by Ni VoL on 16.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CakeMenuList: UIViewController , UITableViewDataSource,UITableViewDelegate, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "Deserts"))
    }

    @IBOutlet weak var tableView: UITableView!
    var products : [ElementProduct]!
    static var kostil = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset.bottom = 70
//        let database = Database()
        products = getProductsByType(type: 2)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = products[indexPath.row]
        var avatar_url: URL
        let cell = tableView.dequeueReusableCell(withIdentifier: "cakeManu" , for : indexPath) as? CakeManu
        
        cell?.productElem = data
        //Name
        cell?.nameLbl.text = data.name
        
        //CoffeeImage
        if data.img != nil{
            cell?.CoffeeImg.kf.setImage(with: URL(string: data.img)!)
        } else{
            cell?.CoffeeImg.image = #imageLiteral(resourceName: "coffee-cup")
        }
        
        if data.active{
            cell?.missingitemLbl.isHidden = true
        } else{
            cell?.missingitemLbl.isHidden = false
        }
        
        //Price
        var price_text = ""
        
        let price = data.price
        price_text += "\(price!) грн"
        
        cell?.priceLbl.text = price_text
        
        return cell!
    }
}
