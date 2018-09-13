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
        Alamofire.request("http://138.68.79.98/api/customers/additionals/?id=\(OrdersVC.coffeeId)").responseJSON { (response) in
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
        let additionalIndex = additional[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "additionCell" , for : indexPath) as? AdditionCell
        print(additionalIndex["name"] ?? "SykaBlat")
        cell?.additionalLbl.text = additionalIndex["name"] as? String

        
        
        
        return cell!
    }
    
}
