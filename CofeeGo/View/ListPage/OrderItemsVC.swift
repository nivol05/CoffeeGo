//
//  OrderItemsVC.swift
//  CofeeGo
//
//  Created by NI Vol on 11/1/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import PopupDialog
import NVActivityIndicatorView

class OrderItemsVC: UIViewController, UITableViewDataSource , UITableViewDelegate ,NVActivityIndicatorViewable {
    
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var refreshOrderBtn: UIButton!
    
    var orderID: Int!
    var order: ElementOrder!
    var orderItems: [ElementOrderItem]!
    var menu: [ElementProduct]!
    var additionals : [[String: Any]] = [[String: Any]]()
    var syrups : [[String: Any]] = [[String: Any]]()

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

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var baristaCOmmentLbl: UILabel!
    @IBOutlet weak var userCommentLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.getOrder()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listIsVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listIsVisible = false
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if orderItems == nil{
                return 0
            }
            return orderItems.count
    
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
            let item = self.orderItems![indexPath.row]
            let product = getProductById(id: item.product)
            
            if product.img != nil{
                cell.img.kf.setImage(with: URL(string: product.img)!)
            } else{
                cell.img.image = #imageLiteral(resourceName: "coffee-cup")
            }
//            let imgUrl = URL(string: product.img!)
//            cell.img.kf.setImage(with: imgUrl)
            cell.nameLbl.text = product.name
            if item.sugar == floor(item.sugar){
                cell.sugarCountLbl.text = "Сахар: \(Int(item.sugar))"
            } else{
                cell.sugarCountLbl.text = "Сахар: \(item.sugar!)"
            }
            cell.coffeePrice.text = "\(item.item_price!) грн"
            cell.priceOrderDone.text = "Всего: \((item.item_price + item.additionals_price)) грн"

            if item.syrups != nil && item.syrups != ""{ // Making syrups string
                let syrupsInStr = item.syrups.components(separatedBy: ", ")
                var syrupsText = "Сиропы: "
                for i in 0..<syrupsInStr.count{
                    let value = syrupsInStr[i]
                    
                    for x in self.syrups{
                        if value == x["name"] as! String{
                            syrupsText.append(x["name"] as! String)
                            syrupsText.append("( +\(x["price"] as! Int) грн)")
                            break
                        }
                    }
                    
                    
                    if i != syrupsInStr.count - 1{
                        syrupsText.append(", ")
                    }
                }
                cell.syrypsLbl.text = syrupsText
            } else {
                cell.syrypsLbl.text = ""
            }
            
            if item.additionals != nil && item.additionals != ""{ // Making adds string
                let addsInStr = item.additionals.components(separatedBy: ", ")
                var addsText = "Добавки: "
                for i in 0..<addsInStr.count{
                    let value = addsInStr[i]
                    
                    for x in self.additionals{
                        if value == x["name"] as! String{
                            addsText.append(x["name"] as! String)
                            addsText.append("( +\(x["price"] as! Int) грн)")
                            break
                        }
                    }
                    
                    
                    if i != addsInStr.count - 1{
                        addsText.append(", ")
                    }
                }
                cell.additionalLbl.text = addsText
            } else {
                cell.additionalLbl.text = ""
            }
            
            if item.species != nil && item.species != ""{
                cell.speciesLbl.text = "Специи: \(item.species!)"
            } else{
                cell.speciesLbl.text = ""
            }
            return cell
        }
    
    
    
    
    func getOrder(){

        getOneOrder(orderId: "\(orderID!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.order = ElementOrder(mas: value as! [String : Any])
    
                if self.order.canceled_barista_message == ""{
                    self.baristaCOmmentLbl.text = "Комментарий бариста: Нету комментария"
                } else {
                    self.baristaCOmmentLbl.text = "Комментарий бариста: \(self.order.canceled_barista_message ?? "Нету комментария")"
                }
                
                if self.order.comment == ""{
                    self.userCommentLbl.text = "Ваш комментарий: Нету комментария"
                } else {
                    self.userCommentLbl.text = "Ваш комментарий: \(self.order.comment!)"
                }
                
                self.setStatusView()
                
                self.getItems()
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getItems(){
        getOrderItemsForOrder(orderId: "\(orderID!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.orderItems = setElementOrderItemList(list: value as! [[String : Any]])
                self.getProducts()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getProducts(){
        getProductsForSpot(spotId: "\(order.coffee_spot!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.menu = setElementProductList(list: value as! [[String : Any]])
                self.getSyrups()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getSyrups(){
        
        var hasSyrup = false
        
        for x in orderItems{
            if x.syrups != nil && x.syrups != ""{
                hasSyrup = true
                break
            }
        }
        
        if hasSyrup{
            getSyrupsForSpot(spotId: "\(order.coffee_spot!)").responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    self.syrups = value as! [[String : Any]]
                    self.getAdds()
                    break
                case .failure(let error):
                    self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                    self.stopAnimating()
                    print(error)
                    break
                }
            }
        } else{
            self.getAdds()
        }
    }
    
    func getAdds(){
        
        var hasAdds = false
        
        for x in orderItems{
            if x.additionals != nil && x.additionals != ""{
                hasAdds = true
                break
            }
        }
        
        if hasAdds{
            getAdditionalsForSpot(spotId: "\(order.coffee_spot!)").responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    self.additionals = value as! [[String : Any]]
                    self.stopAnimating()
                    self.tableView?.reloadData()
                    break
                case .failure(let error):
                    self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                    self.stopAnimating()
                    print(error)
                    break
                }
            }
        } else {
             self.stopAnimating()
            self.tableView?.reloadData()
        }
    }
    
    func getProductById(id: Int) -> ElementProduct{
        var res: ElementProduct!
        for x in self.menu{
            if x.id == id{
                res = x
                break
            }
        }
        return res
    }
    
    func setStatusView(){
        self.statusLbl.text = self.statuses[self.order.status]
        self.statusLbl.textColor = self.statusColors[self.order.status]
        
        if order.status == 1 || order.status == 2{
            cancelOrderBtn.isHidden = false
        } else {
            cancelOrderBtn.isHidden = true
        }
        if order.status == 3 || order.status == 4 || order.status == 6{
            refreshOrderBtn.isHidden = false
        } else {
            refreshOrderBtn.isHidden = true
        }
    }
    
    func cancelOrder(){
        
        var orderToPost = [String : Any]()
        orderToPost["status"] = 4
        
        patchOrder(orderId: "\(order.id!)", order: orderToPost).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.order.status = 4
                self.setStatusView()
                print(value)
                
                // MAKE CANCEL BUTTON HIDDEN
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func itemsIsActive() -> Bool{
        var isActive = true
        for product in menu{
            for item in orderItems{
                if item.product == product.id{
                    if !product.active{
                        isActive = false
                        self.view.makeToast("\(product.name!) временно отсутствует")
                        break
                    }
                }
            }
        }
        return isActive
    }
    
    func checkOrderStatus(_ id : Int){
        getOneOrder(orderId: "\(id)").responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let oneOrder = ElementOrder(mas: value as! [String : Any])
                if oneOrder.status == 6 || oneOrder.status == 3{
                
                    self.view.makeToast("Заказ уже нельзя отменить")
                    
                } else {
                    
                        self.cancelOrder()
                
                }
                
                
                break
            case .failure(let error):
                self.stopAnimating()
                print(error)
                break
            }
            
        }
    }
    
    func isOrderInProcess(){
        getActiveUserOrders(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orders = value as! [[String : Any]]
                if orders.count == 0{
                    self.reUploadOrder()
                    print("USER CAN ORDER")
                } else{
                    self.view.makeToast("У вас есть незавершенный заказ")
                    self.stopAnimating()
                    print("USER HAS ORDERS")
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func reUploadOrder(){
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "finishPostOrder") as! postOrderVC
    print(self.order)
        cell.orderItems = self.orderItems
        cell.order = self.order
        stopAnimating()
        self.present(cell, animated: true, completion: nil)
    }
    
    func showStandardDialog(animated: Bool = true) {
        
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
            self.checkOrderStatus(self.orderID)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    func Time(){
        print("TYT2")
//        let currMins = toMins(time: getTimeNow())
//        let mins = toMins(time: self.order.order_time)
//
//        var minsToOrder = mins - currMins
//        if minsToOrder < 0{
//            minsToOrder += 1440
//        }
        let mins = toMins(time: self.order.order_time)
        
        var minsToOrder = mins - toMins(time: getTimeNow())
        var beforeToday = true
        if !isToday(date: self.order.date!){
            if isBeforeToday(date: self.order.date){
                beforeToday = false
            } else {
                if minsToOrder < 0 {
                    minsToOrder += 1440 // 1440 mins in 24 hrs
                }
            }
        }
        if beforeToday == true{
            if minsToOrder > 3 {
                    getOrder()
                    showStandardDialog()
            } else {
                if order.status == 1{
                        getOrder()
                        showStandardDialog()
                   
                } else {
                    self.view.makeToast("Заказ уже нельзя отменить")
                    
                }
            }
        } else {
                self.view.makeToast("Заказ уже нельзя отменить")
            
        }
    }
    
    @IBAction func moreBtn(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "FullCommetVC") as! FullCommetVC
        
        if self.order.canceled_barista_message == ""{
            cell.baristaComment = "Нету комментария"
        } else {
            cell.baristaComment = "\(self.order.canceled_barista_message ?? "Нету комментария")"
        }
        
        if self.order.comment == ""{
            cell.userComment = "Нету комментария"
        } else {
            cell.userComment = " \(self.order.comment!)"
        }
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    
    @IBAction func barMoreBtn(_ sender: Any) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "FullCommetVC") as! FullCommetVC
        
        
        if self.order.canceled_barista_message == ""{
            cell.baristaComment = "Нету комментария"
        } else {
            cell.baristaComment = "\(self.order.canceled_barista_message ?? "Нету комментария")"
        }
        
        if self.order.comment == ""{
            cell.userComment = "Нету комментария"
        } else {
            cell.userComment = " \(self.order.comment!)"
        }
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    @IBAction func cancelOrderBtn(_ sender: Any) {
        Time()
    }
    
    @IBAction func refreshOrderBtn(_ sender: Any) {
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        if getSpotById(spotId: self.order.coffee_spot).is_active{
            if self.itemsIsActive(){
                self.isOrderInProcess()
            } else{
                stopAnimating()
            }
        } else{
            self.view.makeToast("На данный момент заказы не доступны")
            stopAnimating()
        }
        //        performSegue(withIdentifier: "test", sender: self)
        //        self.navigationController?.pushViewController(cell, animated: true)
        //        performSegue(withIdentifier: "reuploadOrder", sender: self)
        
    }

}
