//
//  ListVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 05.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire
import NVActivityIndicatorView

class ListVC: UIViewController, UITableViewDataSource , UITableViewDelegate , NVActivityIndicatorViewable {
    
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
    
    var refresh : UIRefreshControl!
    
    var orders : [ElementOrder]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UINavigationItem!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var internetTrobleView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Connectivity.isConnectedToInternet() {
//            loadingView.isHidden = false
            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            refresh = UIRefreshControl()
            refresh.backgroundColor = UIColor.clear
            refresh.addTarget(self, action: #selector(ListVC.refreshPage), for: UIControlEvents.valueChanged)
            
            tableView.addSubview(refresh)
            tableView.dataSource = self
            tableView.delegate = self
            getOrders()
        } else {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listIsVisible = true
        if Connectivity.isConnectedToInternet() {
            tableView.isHidden = false
            internetTrobleView.isHidden = true
            getOrders()
        } else {
            tableView.isHidden = true
            internetTrobleView.isHidden = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listIsVisible = false
    }
    
    
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
        
        cornerRatio(view: cell.logoImg , ratio: cell.logoImg.frame.height/2, shadow: false)
        cell.logoImg.kf.setImage(with: logoUrl)
        cell.dateLbl.text = order.date!
        cell.timeLbl.text = order.order_time!
        cell.priceLbl.text = "\(order.full_price!) грн"
        cell.statusLbl.text = statuses[order.status!]
        cell.statusLbl.textColor = statusColors[order.status!]
        if order.status == 1 || order.status == 2{
            cell.cancelOrderBtn.isHidden = false
            cell.cancelOrderBtn.addTarget(self, action: #selector(cancelOrderBtn(sender:)), for: .touchUpInside)
        } else {
            cell.cancelOrderBtn.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = Storyboard.instantiateViewController(withIdentifier: "orderItemsPage") as! OrderItemsVC

        controller.orderID = self.orders[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func refreshPage(){
        if Connectivity.isConnectedToInternet() {
            getOrders()
        }
        
    }
    
    @objc func cancelOrderBtn(sender : UIButton){
        showStandardDialog(tag: sender.tag)
    }
    
    func getOrders(){
        getOrdersForUser(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                self.orders = setElementOrderList(list: value as! [[String : Any]])
                if self.orders.count == 0{
                    self.loadingView.isHidden = false
                } else {
                    self.loadingView.isHidden = true
                }
                self.titleLbl.title = "Ваши заказы (\(self.orders.count))"
                
                if allCoffeeSpots == nil{
                    self.getSpots()
                } else if allCoffeeNets == nil{
                    self.getNets()
                } else{
//                    self.loadingView.isHidden = true
                    self.stopAnimating()
                    self.tableView?.reloadData()
                }
                self.refresh.endRefreshing()
                break
            case .failure(let error):
                self.refresh.endRefreshing()
//                self.loadingView.isHidden = true
                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    
    
    func cancelOrder(order: ElementOrder, elementPos: Int){
        
        var orderToPost = [String : Any]()
        orderToPost["status"] = 4
        
        patchOrder(orderId: "\(order.id!)", order: orderToPost).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                order.status = 4
                self.orders[elementPos] = order
                self.tableView.reloadData()
                print(value)
                
                // MAKE CANCEL BUTTON HIDDEN
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
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
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
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
    
    func showStandardDialog(animated: Bool = true , tag : Int) {
        
        // Prepare the popup
        let title = ""
        let message = "Вы уверены что хотите отменить заказ?"
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
                                    print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "Нет") {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Да") {
            self.cancelOrder(order: self.orders[tag], elementPos: tag)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
}
