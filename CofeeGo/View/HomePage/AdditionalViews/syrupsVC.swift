//
//  syrupsVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire

class syrupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptySyrypView: UIView!
    
    var syrup : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderData.tempSyrups = OrderData.currSyrups
        print("SYRUPS \(OrderData.tempSyrups)")
        
        tableView.isHidden = true

        getSyrupsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            if let responseValue = response.result.value{
                self.syrup = responseValue as! [[String : Any]]
                if self.syrup.count > 0 {
                    
                    self.emptySyrypView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                } else {
                    self.emptySyrypView.isHidden = false
                }
                
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
                isSelected = true
                break
            }
        }
            if !isSelected{
                cell.checkMark.isHidden = true
            }
        cell.syrupNameLbl.text = syrupElem["name"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "syrupCell" , for : indexPath) as! SyrupCell
        
        let syrupElem = syrup[indexPath.row]

        if  cell.checkMark.isHidden == true{

            cell.checkMark.isHidden = false
            OrderData.tempSyrups.append(syrupElem)
            
        } else {
            cell.checkMark.isHidden = true
            var pos = 0
            for i in 0..<OrderData.tempSyrups.count{
                let value = OrderData.tempSyrups[i]
                if "\(value["name"]!)" == "\(syrupElem["name"]!)"{
                    pos = i
                    break
                }
            }
            
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
