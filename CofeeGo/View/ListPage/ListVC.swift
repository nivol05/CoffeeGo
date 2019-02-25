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
    
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var internetTrobleView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        if Connectivity.isConnectedToInternet() {
//            loadingView.isHidden = false
            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            refresh = UIRefreshControl()
            refresh.backgroundColor = UIColor.clear
            refresh.addTarget(self, action: #selector(ListVC.refreshPage), for: UIControlEvents.valueChanged)
            
            tableView.addSubview(refresh)
            tableView.dataSource = self
            tableView.delegate = self
            
        } else {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listIsVisible = true
        if Connectivity.isConnectedToInternet() {
            tableView.isHidden = false
            internetTrobleView.isHidden = true
            if header != nil{
                getOrders()
                bottomLbl.text = "Сделайте заказ и просмотрите его здесь"
            } else {
                loadingView.isHidden = false
                bottomLbl.text = "Для того чтоб появился список заказов нужно войти"
                stopAnimating()
            }
            
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
            cornerRatio(view: cell.transferOrderBtn, ratio: 5, shadow: false)
            cell.transferOrderBtn.isHidden = false
            cell.transferOrderBtn.tag = indexPath.row
            cell.transferOrderBtn.addTarget(self, action: #selector(transferOrder(sender:)), for: .touchUpInside)
            cell.cancelOrderBtn.tag = indexPath.row
            cell.cancelOrderBtn.addTarget(self, action: #selector(cancelOrderBtn(sender:)), for: .touchUpInside)
        } else {
            cell.cancelOrderBtn.isHidden = true
            cell.transferOrderBtn.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = Storyboard.instantiateViewController(withIdentifier: "orderItemsPage") as! OrderItemsVC

        controller.orderID = self.orders[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
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
                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func checkOrderStatus(_ id : Int, _ tag : Int, delay: Bool = false){
        getOneOrder(orderId: "\(id)").responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let oneOrder = ElementOrder(mas: value as! [String : Any])
                
                if oneOrder.status == 6 || oneOrder.status == 3{
                    if delay{
                        self.view.makeToast("Заказ уже нельзя перенести")
                    } else{
                        self.view.makeToast("Заказ уже нельзя отменить")
                    }
                } else {
                    if delay{
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let cell = Storyboard.instantiateViewController(withIdentifier: "finishPostOrder") as! postOrderVC
                        print(self.orders[tag])
                        cell.delay = true
                        cell.order = self.orders[tag]
                        self.stopAnimating()
                        
                        self.present(cell, animated: true, completion: nil)
                    } else{
                        self.cancelOrder(order: self.orders[tag], elementPos: tag)
                    }
                }
                
                
                break
            case .failure(let error):
                self.stopAnimating()
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
                self.stopAnimating()
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
        
//        let order = self.orders[tag]
        // Prepare the popup
        let title = ""
        let message = "Вы уверены, что хотите отменить заказ?"
        
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
            self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            self.checkOrderStatus(self.orders[tag].id, tag)
                //            self.cancelOrder(order: self.orders[tag], elementPos: tag)
            
            self.getOrders()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    func Time(tag: Int, delay: Bool = false){
        print("TYT2")
//        let currMins = toMins(time: getTimeNow())
//        let mins = toMins(time: self.orders[tag].order_time)
//
//        var minsToOrder = mins - currMins
//        if minsToOrder < 0{
//            minsToOrder += 1440
//        }
        
        let mins = toMins(time: self.orders[tag].order_time)
        var beforeToday = true
        var minsToOrder = mins - toMins(time: getTimeNow())
        if !isToday(date: self.orders[tag].date!){
            if isBeforeToday(date: self.orders[tag].date){
                beforeToday = false
            } else {
                if minsToOrder < 0 {
                    minsToOrder += 1440 // 1440 mins in 24 hrs
                }
            }
        }
        if beforeToday == true{
            if minsToOrder > 3{
                
                if !delay{
                    getOrders()
                    showStandardDialog(tag: tag)
                } else{
                    self.checkOrderStatus(self.orders[tag].id, tag, delay: true)
                }
                
            } else {
                if orders[tag].status == 1{
                    if !delay{
                        getOrders()
                        showStandardDialog(tag: tag)
                    } else{
                        self.checkOrderStatus(self.orders[tag].id, tag, delay: true)
                    }
                } else {
                    if !delay{
                    self.view.makeToast("Заказ уже нельзя отменить")
                    } else{
                        self.view.makeToast("Заказ уже нельзя перенести")
                    }
                }
            }
        } else {
            if !delay{
                self.view.makeToast("Заказ уже нельзя отменить")
            } else{
                self.view.makeToast("Заказ уже нельзя перенести")
            }
        }
        
    }
    
    @objc func loadList(){
        //load data here
        getOrders()
        self.tableView.reloadData()
    }
    
    @objc func refreshPage(){
        if Connectivity.isConnectedToInternet() {
            getOrders()
        }
        
    }
    
    @objc func cancelOrderBtn(sender : UIButton){
        
//        let order = self.orders[sender.tag]
        getOrders()
        Time(tag: sender.tag)
    }
    
    @objc func transferOrder(sender : UIButton){
        
        //        let order = self.orders[sender.tag]
        getOrders()
        Time(tag: sender.tag, delay: true)
    }
    
    
}
