//
//  additionalsVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip
import Toast_Swift


class additionalsVC: UIViewController , UITableViewDelegate,UITableViewDataSource,IndicatorInfoProvider{

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : "Дополнения")
        
    }

    @IBOutlet weak var emptyAdditionalsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var additional : [[String: Any]] = [[String: Any]]()
    var selects : [Bool] = [Bool]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
        OrderData.tempAdditionals = OrderData.currAdditionals
        OrderData.countAdditionals = OrderData.tempAdditionals.count
        
        print(OrderData.countAdditionals)
        
        
//        tableView.isHidden = true
        getAdditionalsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.additional = value as! [[String : Any]]
                if self.additional.count > 0{
                    self.selects = [Bool](repeating: false, count: self.additional.count)
                    self.emptyAdditionalsView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.tableView.reloadData()
                }
                else{
                    self.emptyAdditionalsView.isHidden = false
                    print("nema")
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
                break
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additional.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addElem = additional[indexPath.row]
        print("OrderData Index \(indexPath.row)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "additionCell" , for : indexPath) as! AdditionCell
        cell.additionalLbl.text = "\(addElem["name"] as! String) \(addElem["price"] as! Int) грн"

        var isSelected = false

        for i in 0..<OrderData.tempAdditionals.count{
            let value = OrderData.tempAdditionals[i]
            if "\(value["name"]!)" == "\(addElem["name"]!)"{
                isSelected = true
                break
            }
        }
        
        if !isSelected{
            cell.checkMark.isHidden = true
            selects[indexPath.row] = true
        } else{
            cell.checkMark.isHidden = false
            selects[indexPath.row] = false
        }
        print("OrderData IsHiden \(cell.checkMark.isHidden)")

        print("OrderData create")

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addElem = additional[indexPath.row]
        print("OrderData Index \(indexPath.row)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "additionCell" , for : indexPath) as! AdditionCell
        
        print("OrderData IsHiden \(cell.checkMark.isHidden)")

        
         if selects[indexPath.row]{
            if OrderData.countAdditionals < 5{
                OrderData.tempAdditionals.append(addElem)
                OrderData.countAdditionals += 1
                print("OrderData add")
            } else{
                // MAKE TOAST
            }
//            cell.checkMark.isHidden = false
//            selects[indexPath.row] = false
            
        } else {
//           cell.checkMark.isHidden = true
//            selects[indexPath.row] = true

            var pos = 0
            for i in 0..<OrderData.tempAdditionals.count{
                let value = OrderData.tempAdditionals[i]
                if "\(value["name"]!)" == "\(addElem["name"]!)"{
                    pos = i
                    break
                }
            }
            print("OrderData remove")
            OrderData.countAdditionals -= 1
            OrderData.tempAdditionals.remove(at: pos)
            
        }
//        tableView.reloadData()

        tableView.reloadRows(at: [indexPath], with: .none)
        
        print(OrderData.countAdditionals)
    }
    
}
