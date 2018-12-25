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
    
    var t_count:Int = 0
    var lastCell: DropDownCell = DropDownCell()
    var button_tag : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let database = Database()
        self.tableView.contentInset.bottom = 70
        products = getProductsByType(type: 9)
        
        tableView.register(UINib(nibName: "DropDownCell", bundle: nil), forCellReuseIdentifier: "CoffeeManu")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == button_tag {
            print("last cell is seen!!")
            //            self.tableView.beginUpdates()
            
            let previousCellTag = button_tag
            
            if lastCell.cellExists {
                print("per")
                self.lastCell.animate(duration: 0.3, c: {
                    self.view.layoutIfNeeded()
                })
                
                if indexPath.row == button_tag {
                    print("vtor")
                    button_tag = -1
                    lastCell = DropDownCell()
                }
                
            }
            
            if indexPath.row != previousCellTag {
                button_tag = indexPath.row
                print("tre")
                
                
                lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! DropDownCell
                
                self.lastCell.animate(duration: 0.3, c: {
                    self.view.layoutIfNeeded()
                })
                
            }
            
            self.tableView.endUpdates()
            self.tableView.beginUpdates()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeManu" , for : indexPath) as! DropDownCell
        
        cell.nameLbl.text = data.name
        
        //CoffeeImage
        if data.img != nil{
            cell.CoffeeImg.kf.setImage(with: URL(string: data.img)!)
        } else{
            cell.CoffeeImg.image = #imageLiteral(resourceName: "coffee-cup")
        }
        
        var price_text = ""
        var onlyPrice : Bool = true
        //
        //            // Checking for small cup
        let l_cup = data.l_cup!
        if l_cup != 0 {
            
            cell.BGSmallCup.isHidden = false
            cell.smallCupPrice.isHidden = false
            
            price_text += "\(l_cup) грн"
            cell.smallCupPrice.text = "\(l_cup) грн"
            onlyPrice = false
        } else {
            cell.BGSmallCup.isHidden = true
            cell.smallCupPrice.isHidden = true
        }
        //
        //            // Checking for medium cip
        let m_cup = data.m_cup!
        if m_cup != 0 {
            price_text += " / \(m_cup) грн"
            cell.middleCupPrice.text = "\(m_cup) грн"
            onlyPrice = false
        }
        //
        //            // Checking for big cup
        let b_cup = data.b_cup!
        if b_cup != 0 {
            
            cell.BGBigCup.isHidden = false
            cell.bigCupPrice.isHidden = false
            
            price_text += " / \(b_cup) грн"
            cell.bigCupPrice.text = "\(b_cup) грн"
            
            cell.helperView.isHidden = true
            onlyPrice = false
        } else {
            cell.BGBigCup.isHidden = true
            cell.bigCupPrice.isHidden = true
            cell.helperView.isHidden = false
        }
        //
        //            // Set the only price
        let price = data.price!
        
        if onlyPrice{
            price_text += "\(price) грн"
            cell.middleCupPrice.text = "\(price) грн"
            cell.helperView.isHidden = true
            
            cell.capView.isHidden = true
        } else {
            cell.capView.isHidden = false
        }
        
        cell.productElem = data
        cell.coffeePrice = data.price
        cell.priceLbl.text = price_text
        
        if data.active{
            cell.missingItemLbl.isHidden = true
            cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
        } else{
            cell.missingItemLbl.isHidden = false
        }
        
        
        cell.aditionalStaff.addTarget(self, action: #selector(cellAditional(sender:)), for: .touchUpInside)
        cell.addToOrderBtn.addTarget(self, action: #selector(closeCell(sender:)), for: .touchUpInside)
        
        t_count += 1
        cell.cellExists = true
        
        cell.open.tag = indexPath.row
        
        
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        
        return cell
    }
    
    @objc func cellAditional(sender:UIButton){
        performSegue(withIdentifier: "aditionalView2", sender: self)
    }
    
    @objc func cellOpened(sender:UIButton) {
        //        tableView.reloadData()
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            print("Close1")
            
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutMarginsDidChange()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = DropDownCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            print("Close2")
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! DropDownCell
            //
            //            lastCell.stuffView.isHidden = false
            //            lastCell.stuffView.alpha = 1
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutMarginsDidChange()
            })
            
        }
        
        OrderData.currAdditionals.removeAll()
        OrderData.currSpecies.removeAll()
        OrderData.currSyrups.removeAll()
        
        self.tableView.endUpdates()
    }
    
    @objc func closeCell(sender:UIButton){
        self.tableView.beginUpdates()
        
        if lastCell.cellExists {
            
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutMarginsDidChange()
            })
            button_tag = -1
            lastCell = DropDownCell()
            
        }
        
        OrderData.currAdditionals.removeAll()
        OrderData.currSpecies.removeAll()
        OrderData.currSyrups.removeAll()
        
        self.tableView.endUpdates()
    }

}
