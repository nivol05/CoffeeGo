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
    
    var postedId : Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postOrder(spot_id: Int, full_price: Int, date: String, comment: String, orderTime: String){
    
        let orderToPost : [String : Any] = [
        "coffee_spot": spot_id,
       "full_price":  full_price,
        "date": date,
        "user":  31 ,// TODO: USER ID,
        "comment": comment,
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
        orderItemPost["item_price"] = item.getProductPrice()
        
        orderItemPost["product"] = item.product_id

        orderItemPost["sugar"] = item.sugar;
        
        orderItemPost["species"] = item.getSpeciesString()
        
        orderItemPost["syrups"] = item.getSyrupsString()
        
        orderItemPost["additionals"] = item.getAdditionalsString()
        
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
        let id = Int(OrdersVC.coffeeId)
        print("Post")
        postOrder(spot_id: id, full_price: OrderData.getAllPrice(), date: "2018-10-15", comment: "", orderTime: "23 : 40")
        dismiss(animated: true, completion: nil)
    }
    
}
