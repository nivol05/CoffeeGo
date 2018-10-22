//
//  speciesVC.swift
//  CofeeGo
//
//  Created by NI Vol on 10/15/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class speciesVC: UIViewController,  UITableViewDelegate,UITableViewDataSource {

   
    @IBOutlet weak var emptyAdditionalsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var species : [[String: Any]] = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        getSpeciesForSpot(spotId: "\(OrdersVC.coffeeId)").responseJSON { (response) in
            if let responseValue = response.result.value{
                self.species = responseValue as! [[String : Any]]
                if self.species.count > 0{
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
        return species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addElem = species[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "speciesCell" , for : indexPath) as! speciesCell
        cell.speciesNameLbl.text = addElem["name"] as? String
        
        for i in 0..<OrderData.tempSpecies.count{
            let value = OrderData.tempSpecies[i]
            var isSelected = false
            if value == "\(addElem["name"]!)"{
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
        
        let addElem = species[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "speciesCell" , for : indexPath) as! speciesCell
        
        if  cell.checkMark.isHidden == true{
            
            cell.checkMark.isHidden = false
            OrderData.tempSpecies.append(addElem["name"] as! String)
            
        } else {
            cell.checkMark.isHidden = true
            
            OrderData.tempSpecies.removeAll { $0 == addElem["name"] as! String}
            
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }


}
