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
        
        tableView.isHidden = true

        Alamofire.request("http://138.68.79.98/api/customers/syrups/?id=\(OrdersVC.coffeeId)").responseJSON { (response) in
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
        let additionalIndex = syrup[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "syrupCell" , for : indexPath) as? SyrupCell
        print(additionalIndex["name"] ?? "SykaBlat")
        cell?.syrupNameLbl.text = additionalIndex["name"] as? String
        
        
        return cell!
    }

}
