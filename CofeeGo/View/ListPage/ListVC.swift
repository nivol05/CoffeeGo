//
//  ListVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 05.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class ListVC: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    let statuses = [
        "",
        "Ожидает подтверждения",
        "Подтверждено",
        "Завершено",
        "Отклонено клиентом",
        "Готовится",
        "Отклонено заведением",
        "Ожидает заказчика"
    ]
    
    let statusColors = [
        nil,
        UIColor.yellow,
        UIColor.yellow,
        UIColor.green,
        UIColor.red,
        UIColor.yellow,
        UIColor.red,
        UIColor.yellow
    ]
    
    var orders : [ElementOrder]!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orders == nil{
            return 0
        }
        return orders.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        let order = self.orders![indexPath.row]
        let company = getNet(netId: getNetId(spotId: order.coffee_spot!))
        cell.addressLbl.text = self.getStreet(spotId: order.coffee_spot!)
        cell.coffeeNameLbl.text = company.name_other!
        let logoUrl = URL(string: company.logo_img!)
        cell.logoImg.kf.setImage(with: logoUrl)
        cell.dateLbl.text = order.date!
        cell.timeLbl.text = order.order_time!
        cell.priceLbl.text = "\(order.full_price!) грн"
        cell.statusLbl.text = statuses[order.status!]
        cell.statusLbl.textColor = statusColors[order.status!]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getOrders()
    }
    
    func getOrders(){
        getOrdersForUser(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                self.orders = setElementOrderList(list: value as! [[String : Any]])
                if allCoffeeSpots == nil{
                    self.getSpots()
                } else if allCoffeeNets == nil{
                    self.getNets()
                } else{
                    self.tableView?.reloadData()
                }
                
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getSpots(){
        getCoffeeSpots().responseJSON { (response) in
            if let responseValue = response.result.value{
                allCoffeeSpots = setElementCoffeeSpotList(list: responseValue as! [[String : Any]])
                if allCoffeeNets == nil{
                    self.getNets()
                } else{
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    func getNets(){
        getCoffeeNets().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                allCoffeeNets = setElementCoffeeNetList(list: value as! [[String : Any]])
                self.tableView?.reloadData()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getStreet(spotId: Int) -> String{
        var street = ""
        for x in allCoffeeSpots{
            if x.id == spotId{
                street = x.address
                break
            }
        }
        return street
    }
    
    func getNetId(spotId: Int) -> Int{
        var id = 0
        for x in allCoffeeSpots{
            if x.id == spotId{
                id = x.company
                break
            }
        }
        return id
    }
    
    func getNet(netId: Int) -> ElementCoffeeNet{
        var company : ElementCoffeeNet!
        for x in allCoffeeNets{
            if x.id == netId{
                company = x
                break
            }
        }
        return company
    }
}
