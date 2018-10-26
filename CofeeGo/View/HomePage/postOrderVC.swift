//
//  postOrderVCViewController.swift
//  CofeeGo
//
//  Created by NI Vol on 10/13/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import SwiftyJSON

class postOrderVC: UIViewController {
    
    var currentTime : Int!
    var postedId : Int!
    @IBOutlet weak var timePicker: UITextField!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var orderTimeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTime = toMins(time: getTimeNow())
        timePicker.text = "50"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postOrder(spot_id: Int, date: String, orderTime: String){
    
        let orderToPost : [String : Any] = [
        "coffee_spot": spot_id,
       "full_price":  OrderData.getAllPrice(),
        "date": date,
        "user":  current_coffee_user.id,
        "comment": commentView.text!,
        "order_time": orderTime,
        "status": 1,
        "canceled_barista_message": ""
        ]
        print("Post \(orderToPost)")
        // POST TODAYS DATE OR TOMMOROWS
//        if(date == null) {
//            orderPost.date = calendarUtils.getDateString(calendarUtils.getCurrentDate());
//        } else {
//            orderPost.date = calendarUtils.getDateString(date.getTime());
//        }
        
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
                print(error)
                break
            }
        }
    }
    
    func postOrderItem(pos : Int){
       
        let item = OrderData.orderList[pos]
        
        var orderItemPost = [String : Any]()
        orderItemPost["order"] = self.postedId;
        
        orderItemPost["cup_size"] = item.cup_size
        orderItemPost["item_price"] = item.product_price
        
        orderItemPost["product"] = item.product_id

        orderItemPost["sugar"] = item.sugar;
        
        orderItemPost["species"] = item.getSpeciesString()
        
        orderItemPost["syrups"] = item.getSyrupsString()
        
        orderItemPost["additionals"] = item.getAdditionalsString()
        
        orderItemPost["additionals_price"] = (item.getProductPrice() - item.product_price) // CHANGED
        
        CofeeGo.postOrderItem(orderItemRes: orderItemPost).responseJSON { (response) in
            if response.result.value != nil{
                print("Post succes")
                if pos != OrderData.orderList.count - 1{
                    self.postOrderItem(pos: pos + 1)

                } else {
                    self.finishOrder()
                }
            } else{
                print("ZAPOOPA")
            }
        }
    }
    //Move to orders tab
    func finishOrder(){
        
    }
    
    
    @IBAction func confirmOrder(_ sender: Any) {
        let id = current_coffee_spot.id
        print("Post")
        currentTime = toMins(time: getTimeNow())
        print("Post \(getTime(minutes: currentTime!))")
        let orderTime = Int(timePicker.text!)!
        if timePicker.text! == "" || orderTime < 5{
            // MAKE WARNING NOT LESS THAN 5
        } else{
            let pickedTime = getTime(minutes: (currentTime + orderTime))
            
            if timeInRange(time: pickedTime, startRange: current_coffee_spot.time_start, endRange: current_coffee_spot.time_finish){
                if compareMins(first: currentTime, second: toMins(time: pickedTime)) == -1 {
                    postOrder(spot_id: id!, date: getCurrentDate(), orderTime: pickedTime)
                } else {
                    postOrder(spot_id: id!, date: getTomorrowDate(), orderTime: pickedTime)
                }
                dismiss(animated: true, completion: nil)
            } else {
                // MAKE WARNING COFFEE WORK TIME FROM START TO END
            }
        }
    }
    
}
