//
//  additionalsVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire

class additionalsVC: UIViewController , UITableViewDelegate,UITableViewDataSource{


    @IBOutlet weak var emptyAdditionalsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var additional : [[String: Any]] = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        getAdditionalsForSpot(spotId: "\(OrdersVC.coffeeId)").responseJSON { (response) in
            if let responseValue = response.result.value{
                self.additional = responseValue as! [[String : Any]]
                if self.additional.count > 0{
                    self.emptyAdditionalsView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
                else{
                    self.emptyAdditionalsView.isHidden = false
                    print("nema")
                }
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additional.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addElem = additional[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "additionCell" , for : indexPath) as! AdditionCell
        cell.additionalLbl.text = addElem["name"] as? String

        for i in 0..<OrderData.tempAdditionals.count{
            let value = OrderData.tempAdditionals[i]
            var isSelected = false
            if "\(value["name"]!)" == "\(addElem["name"]!)"{
                cell.checkMark.isHidden = false
                isSelected = true
                break
            }
            if !isSelected{
                cell.checkMark.isHidden = true
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addElem = additional[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "additionCell" , for : indexPath) as! AdditionCell
        
         if  cell.checkMark.isHidden == true{
            
            cell.checkMark.isHidden = false
            OrderData.tempAdditionals.append(addElem)
            
        } else {
           cell.checkMark.isHidden = true
            var pos = 0
            for i in 0..<OrderData.tempAdditionals.count{
                let value = OrderData.tempAdditionals[i]
                if "\(value["name"]!)" == "\(addElem["name"]!)"{
                    pos = i
                    break
                }
            }
            
            OrderData.tempAdditionals.remove(at: pos)
            
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
