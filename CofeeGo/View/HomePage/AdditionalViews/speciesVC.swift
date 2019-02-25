//
//  speciesVC.swift
//  CofeeGo
//
//  Created by NI Vol on 10/15/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class speciesVC: UIViewController,  UITableViewDelegate,UITableViewDataSource,IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title : "Специи")
    }
   
    @IBOutlet weak var emptyAdditionalsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var species : [[String: Any]] = [[String: Any]]()
    var selects : [Bool] = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
        
        OrderData.tempSpecies = OrderData.currSpecies
        OrderData.countSpecies = OrderData.tempSpecies.count
        
//        tableView.isHidden = true
        getSpeciesForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.species = value as! [[String : Any]]
                if self.species.count > 0{
                    self.selects = [Bool](repeating: false, count: self.species.count)
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
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
                print(error)
                break
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addElem = species[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "speciesCell" , for : indexPath) as! speciesCell
        cell.speciesNameLbl.text = addElem["name"] as? String
        var isSelected = false

        for i in 0..<OrderData.tempSpecies.count{
            let value = OrderData.tempSpecies[i]
            if "\(value["name"]!)" == "\(addElem["name"]!)"{
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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addElem = species[indexPath.row]
        
        
        if  selects[indexPath.row]{
            
//            selects[indexPath.row] = false
            if OrderData.countSpecies < 5{
             
                OrderData.tempSpecies.append(addElem)
                OrderData.countSpecies += 1
            } else{
                // MAKE TOAST
            }
            
        } else {
//            selects[indexPath.row] = true
            var pos = 0
            for i in 0..<OrderData.tempSpecies.count{
                let value = OrderData.tempSpecies[i]
                if "\(value["name"]!)" == "\(addElem["name"]!)"{
                    pos = i
                    break
                }
            }
            OrderData.countSpecies -= 1
            OrderData.tempSpecies.remove(at: pos)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }


}
