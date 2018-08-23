//
//  CoffeeMenuList.swift
//  CofeeGo
//
//  Created by Ni VoL on 16.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Kingfisher

class CoffeeMenuList: UIViewController , UITableViewDataSource, UITableViewDelegate {

    var t_count:Int = 0
    var lastCell: DropDownCell = DropDownCell()
    var button_tag : Int = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var test : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test = User.i[0] as! [[String : Any]]
        print(test)
        self.tableView.contentInset.bottom = 50
//        tableView = UITableView(frame: view.frame)
//        tableView.layer.frame.size.height = view.frame.height * 1.5
//        tableView.frame.origin.y += 125
        tableView.register(UINib(nibName: "DropDownCell", bundle: nil), forCellReuseIdentifier: "CoffeeManu")

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.allowsSelection = false
//        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == button_tag {
            return 365
        } else {
            return 140
        }
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = test[indexPath.row]
        var avatar_url: URL
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeManu" , for : indexPath) as! DropDownCell
//        print(data)
        
        //Name
        cell.nameLbl.text = data["name"] as? String
        
        //CoffeeImage
        avatar_url = URL(string: data["img"] as! String)!
        cell.CoffeeImg.kf.setImage(with: avatar_url)
        
        var price_text = ""
        var onlyPrice : Bool = true
        //
        //            // Checking for small cup
        let l_cup = data["l_cup"] as! Int
        if l_cup != 0 {
            
            cell.BGSmallCup.isHidden = false
            cell.smallCupPrice.isHidden = false
            
            price_text += "\(l_cup) grn / "
            cell.smallCupPrice.text = "\(l_cup) grn"
            onlyPrice = false
        } else {
            cell.BGSmallCup.isHidden = true
            cell.smallCupPrice.isHidden = true
        }
        //
        //            // Checking for medium cip
        let m_cup = data["m_cup"] as! Int
        if m_cup != 0 {
            price_text += "\(m_cup) grn / "
            cell.middleCupPrice.text = "\(m_cup) grn"
            cell.widthModdleBtn.constant = 90
            cell.heightMiddleBtn.constant = 95
            onlyPrice = false
        }
        //
        //            // Checking for big cup
        let b_cup = data["b_cup"] as! Int
        if b_cup != 0 {
            
            cell.BGBigCup.isHidden = false
            cell.bigCupPrice.isHidden = false
            
            price_text += "\(b_cup) grn"
            cell.bigCupPrice.text = "\(b_cup) grn"
            
            onlyPrice = false
        } else {
            cell.BGBigCup.isHidden = true
            cell.bigCupPrice.isHidden = true
        }
        //
        //            // Set the only price
        let price = data["price"] as! Int
        
        if onlyPrice{
            price_text += "\(price) grn"
            cell.middleCupPrice.text = "\(price) grn"
            cell.widthModdleBtn.constant = 110
            cell.heightMiddleBtn.constant = 120
        }

        cell.coffeePrice = cell.middleCupPrice.text!
        cell.priceLbl.text = price_text
        
        cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
        cell.aditionalStaff.addTarget(self, action: #selector(cellAditional(sender:)), for: .touchUpInside)
        
        t_count += 1
        cell.cellExists = true
        
        cell.open.tag = indexPath.row

        
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        
        return cell
    }
    @objc func cellAditional(sender:UIButton){
        performSegue(withIdentifier: "aditionalView", sender: self)
//        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let cell = Storyboard.instantiateViewController(withIdentifier: "aditionalStaff") as! AdditionalStaffForCoffee
//        self.navigationController?.pushViewController(cell, animated: true)
        
    }
    
    @objc func cellOpened(sender:UIButton) {
//        tableView.reloadData()
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = DropDownCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! DropDownCell
//            
//            lastCell.stuffView.isHidden = false
//            lastCell.stuffView.alpha = 1
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutIfNeeded()
            })
            
        }
        self.tableView.endUpdates()
    }

}
