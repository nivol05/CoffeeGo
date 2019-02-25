//
//  syrupsVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip


class syrupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : "Сиропы")
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptySyrypView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var syrup : [[String: Any]] = [[String: Any]]()
    var selects : [Bool] = [Bool]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
        OrderData.tempSyrups = OrderData.currSyrups
        OrderData.countSyryps = OrderData.tempSyrups.count
        
        print("SYRUPS \(OrderData.tempSyrups)")
        
//        tableView.isHidden = true

        getSyrupsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.syrup = value as! [[String : Any]]
                if self.syrup.count > 0 {
                    self.selects = [Bool](repeating: false, count: self.syrup.count)
                    self.emptySyrypView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.tableView.reloadData()
                } else {
                    self.emptySyrypView.isHidden = false
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.loadingIndicator.isHidden = true
                print(error)
                break
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syrup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let syrupElem = syrup[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "syrupCell" , for : indexPath) as! SyrupCell
        var isSelected = false
        
        for i in 0..<OrderData.tempSyrups.count{
            let value = OrderData.tempSyrups[i]
            if "\(value["name"]!)" == "\(syrupElem["name"]!)"{
                cell.checkMark.isHidden = false
                selects[indexPath.row] = false
                isSelected = true
                break
            }
        }
        if !isSelected{
            cell.checkMark.isHidden = true
            selects[indexPath.row] = true
        }
        cell.syrupNameLbl.text = "\(syrupElem["name"] as! String) \(syrupElem["price"] as! Int) грн"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "syrupCell" , for : indexPath) as! SyrupCell
        
        let syrupElem = syrup[indexPath.row]

        if  selects[indexPath.row]{
            if OrderData.countSyryps < 3{
                OrderData.tempSyrups.append(syrupElem)
                OrderData.countSyryps += 1
            } else{
                // MAKE TOAST
            }
//            selects[indexPath.row] = false
            
            
        } else {
//            selects[indexPath.row] = true
            var pos = 0
            for i in 0..<OrderData.tempSyrups.count{
                let value = OrderData.tempSyrups[i]
                if "\(value["name"]!)" == "\(syrupElem["name"]!)"{
                    pos = i
                    break
                }
            }
            OrderData.countSyryps -= 1
            OrderData.tempSyrups.remove(at: pos)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//            if cell.accessoryType == .checkmark {
//                cell.accessoryType = .none
//            } else {
//                cell.accessoryType = .checkmark
//            }
//        }
//    }

}
