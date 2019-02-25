//
//  postOrderVCViewController.swift
//  CofeeGo
//
//  Created by NI Vol on 10/13/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class postOrderVC: UIViewController , NVActivityIndicatorViewable  {
    
    var currentTime : Int!
    var postedId : Int!
    
    var order: ElementOrder!
    var orderItems: [ElementOrderItem]!
    
    var delay: Bool = false
    var reloadList: reloadProtocol!
    
    let buttonsColors = [
        UIColor.init(red: 1, green: 111/255, blue: 0, alpha: 1),
        
        UIColor.init(white: 50/100, alpha: 1)]
    
//    @IBOutlet weak var timePicker: UITextField!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var orderTimeLbl: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var cancelInfoView: UIView!
    @IBOutlet weak var orderDataView: ZFRippleButton!
    @IBOutlet weak var takeaway: UIStackView!
    @IBOutlet weak var takeAwaySwitch: UISwitch!
    
    @IBOutlet weak var cancelInfoSwitch: UISwitch!
    @IBOutlet weak var cancelInfoAccept: UIButton!
    @IBOutlet weak var cancelInfoCanceled: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interface()
        
        if order != nil{
            current_coffee_spot = getSpotById(spotId: order.coffee_spot)
        }
        
        currentTime = toMins(time: getTimeNow())

        let calendar = Calendar.current
        var components = DateComponents()
        var compMax = DateComponents()
        
        compMax.hour = 0
        compMax.minute = Int(current_coffee_spot.max_order_time ?? "1440")
        
        components.hour = 0
        components.minute = Int(current_coffee_spot.min_order_time ?? "5")
        
        orderTimeLbl.text = getTime(minutes: currentTime + Int(current_coffee_spot.min_order_time ?? "5")!)
        
        timePicker.setDate(calendar.date(from: components)!, animated: false)
        timePicker.date = calendar.date(from: components)!
        
        timePicker.minimumDate = calendar.date(from: components)!
        timePicker.maximumDate = calendar.date(from: compMax)!
        
        
//        timePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

//        timePicker.text = "50"
        // Do any additional setup after loading the view.
    }
    
    func interface(){
        
        cornerRatio(view: commentView, ratio: 5, shadow: true)
        cancelInfoAccept.backgroundColor = buttonsColors[0]
        cancelInfoCanceled.backgroundColor = buttonsColors[0]
        cornerRatio(view: cancelInfoAccept, ratio: 5, shadow: true)
        cornerRatio(view: cancelInfoCanceled, ratio: 5, shadow: true)
        cornerRatio(view: cancelInfoView, ratio: 5, shadow: true)
        
        self.hideKeyboardWhenTappedAround()
        
        if isCancelInfoAccepted(){
            cancelInfoView.isHidden = true
            orderDataView.alpha = 1
        } else{
            cancelInfoView.isHidden = false
            orderDataView.alpha = 0
        }
        
    }
    
    
    
    func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        let calendar = Calendar.current
        if let hour = components.hour, let min = components.minute {
            
            print("DATE \(hour) \(min)")
            self.orderTimeLbl.text = getTime(minutes: currentTime + min + (hour * 60))
            
            timePicker.setDate(calendar.date(from: components)!, animated: true)
            
        }
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postOrder(date: String, orderTime: String){
    
        var orderToPost : [String : Any] = [String : Any]()
        if order != nil{
            orderToPost = [
                "coffee_spot": order.coffee_spot,
                "full_price":  order.full_price,
                "date": date,
                "user":  order.user,
                "username": current_coffee_user.first_name!,
                "comment": commentView.text!,
                "order_time": orderTime,
                "status": 1,
                "canceled_barista_message": "",
                "takeaway" : takeAwaySwitch.isOn
            ]
        } else {
            orderToPost = [
                "coffee_spot": current_coffee_spot.id,
                "full_price":  OrderData.getAllPrice(),
                "date": date,
                "user":  current_coffee_user.id,
                "username": current_coffee_user.first_name!,
                "comment": commentView.text!,
                "order_time": orderTime,
                "status": 1,
                "canceled_barista_message": "",
                "takeaway" : takeAwaySwitch.isOn
                
            ]
        }
        print("Post \(orderToPost)")
        
        CofeeGo.postOrder(orderRes: orderToPost).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                self.postedId = jsonData["id"].int
                print(self.postedId)
                self.postOrderItem(pos: 0)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func postOrderItem(pos : Int){
       
        
        var orderItemPost = [String : Any]()
        if order != nil{
            let orderItem = orderItems[pos]
            
            orderItemPost["order"] = self.postedId
            orderItemPost["cup_size"] = orderItem.cup_size!
            orderItemPost["item_price"] = orderItem.item_price!
            orderItemPost["product"] = orderItem.product!
            orderItemPost["sugar"] = orderItem.sugar!
            orderItemPost["species"] = orderItem.species!
            orderItemPost["syrups"] = orderItem.syrups!
            orderItemPost["additionals"] = orderItem.additionals!
            orderItemPost["additionals_price"] = orderItem.additionals_price!
        } else{
            let item = OrderData.orderList[pos]

            orderItemPost["order"] = self.postedId
            orderItemPost["cup_size"] = item.cup_size
            orderItemPost["item_price"] = item.product_price
            orderItemPost["product"] = item.product_id
            orderItemPost["sugar"] = item.sugar;
            orderItemPost["species"] = item.getSpeciesString()
            orderItemPost["syrups"] = item.getSyrupsString()
            orderItemPost["additionals"] = item.getAdditionalsString()
            orderItemPost["additionals_price"] = (item.getProductPrice() - item.product_price)
        }
        print(orderItemPost)
        
        
        
        var fin = false
        if order != nil{
            if pos != orderItems.count - 1{
                fin = true
            }
        } else{
            if pos != OrderData.orderList.count - 1{
                fin = true
            }
        }
        
        CofeeGo.postOrderItem(orderItemRes: orderItemPost).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("Post succes \(value)")
                if fin{
                    self.postOrderItem(pos: pos + 1)
                } else {
                    self.finishOrder()
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
    
    //Move to orders tab
    func finishOrder(delay: Bool = false){
        order = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmOrder(_ sender: Any) {
        print("Post")
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        currentTime = toMins(time: getTimeNow())
        print("Post \(getTime(minutes: currentTime!))")
                let date = self.timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        
        let orderTime = hour * 60 + minute
        
        let pickedTime = getTime(minutes: (currentTime + orderTime) % 1440)
        
        if !delay{
            if order != nil{
                current_coffee_spot = getSpotById(spotId: order.coffee_spot)
            }
            
            
            
            if timeInRange(time: pickedTime, startRange: current_coffee_spot.time_start!, endRange: current_coffee_spot.time_finish!){
                print("Her")
                if orderTime < Int(current_coffee_spot.min_order_time) ?? 5{
                    self.view.makeToast("Нельзя заказать раньше \(current_coffee_spot.min_order_time ?? "5") минут")
                    self.stopAnimating()
                } else {
                    if compareMins(first: currentTime, second: toMins(time: pickedTime)) == -1 {
                        postOrder(date: getCurrentDate(), orderTime: pickedTime)
                    } else {
                        postOrder(date: getTomorrowDate(), orderTime: pickedTime)
                    }
                    //                dismiss(animated: true, completion: nil)
                    isOrdered = true
                    performSegue(withIdentifier: "showFirstView", sender: nil)
                    //
                }
            } else {
                print("gtn")
                print("min \(current_coffee_spot.min_order_time!)")
                self.view.makeToast("Кофейня работает (\(current_coffee_spot.time_start!) - \(current_coffee_spot.time_finish!))")
            }
        } else {
            delayOrder(orderTime: pickedTime)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func delayOrder(orderTime: String){
        var orderToPost = [String : Any]()
        orderToPost["delayed_order"] = true
        orderToPost["order_time"] = orderTime
        
        patchOrder(orderId: "\(self.order.id!)", order: orderToPost).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.finishOrder(delay: true)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                self.stopAnimating()
                break
            }
        }
    }
    func tryReuploadOrder(){
        if self.order.id != nil{
            commentView.text = order.comment
        }
    }
    
    @IBAction func timePicker(_ sender: UIDatePicker) {
        print(sender.date)
        dateChanged(sender)
    }
    
    @IBAction func cancelInfoSwitched(_ sender: Any) {
        if cancelInfoSwitch.isOn{
            cancelInfoCanceled.isEnabled = false
            cancelInfoCanceled.backgroundColor = buttonsColors[1]
        } else{
            cancelInfoCanceled.isEnabled = true
            cancelInfoCanceled.backgroundColor = buttonsColors[0]
        }
    }
    
    @IBAction func cancelInfoAccepted(_ sender: Any) {
        fadeView(view: orderDataView, delay: 0.2, isHiden: false)
        cancelInfoView.isHidden = true
        //        orderDataView.isHidden = false
        setCancelInfoAccepted(accepted: cancelInfoSwitch.isOn)
    }
    
}
