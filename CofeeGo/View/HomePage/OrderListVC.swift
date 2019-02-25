//
//  OrderListVC.swift
//  CofeeGo
//
//  Created by NI Vol on 11/7/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Toast_Swift

class OrderListVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var sliderViewStic: UIView!
    @IBOutlet weak var bottomBgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var urOrderLbl: UILabel!
    @IBOutlet weak var sumLbl: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var elementsCountBG: UIView!
    @IBOutlet weak var elementsCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interface()
        
        elementsCountBG.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        OrderData.controller = self
        
        if header != nil{
            urOrderLbl.text = "Ваш заказ"
        } else {
            urOrderLbl.text = "Войдите чтоб заказать"
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        elementsCount.text = "\(OrderData.orderList.count)"
        
        

        
        if OrderData.orderList.count == 0{
            fadeView(view: elementsCountBG, delay: 0.2, isHiden: true)
            emptyView.isHidden = false
        } else {
            self.elementsCountBG.isHidden = false
            fadeView(view: elementsCountBG, delay: 0.2, isHiden: false)
            emptyView.isHidden = true
        }
        return OrderData.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let orderItem = OrderData.orderList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderList
        
        cell.nameLbl.text = orderItem.product_name
        cell.img.image = orderItem.imageUrl
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtn(sender:)) , for: .touchUpInside)
        
        cell.coffeePrice.text = "\(orderItem.product_price!) грн"
        cell.priceOrderDone.text = "Всего: \(orderItem.getProductPrice()) грн"
        
        if orderItem.syrups.count > 0 { // Making syrups string
            var syrupsText = "Сиропы: "
            for i in 0..<orderItem.syrups.count{
                let value = orderItem.syrups[i]
                
                syrupsText.append(value["name"] as! String)
                syrupsText.append("( +\(value["price"] as! Int) грн)")
                
                if i != orderItem.syrups.count - 1{
                    syrupsText.append(", ")
                }
            }
            cell.syrypsLbl.text = syrupsText
        } else {
            cell.syrypsLbl.text = ""
        }
        
        if orderItem.additionals.count > 0 { // Making adds string
            var addsString = "Додатки: "
            for i in 0..<orderItem.additionals.count{
                let value = orderItem.additionals[i]
                
                addsString.append(value["name"] as! String)
                addsString.append("( +\(value["price"] as! Int) грн)")
                
                if i != orderItem.additionals.count - 1{
                    addsString.append(", ")
                }
            }
            cell.additionalLbl.text = addsString
        } else {
            cell.additionalLbl.text = ""
        }
        
        if orderItem.species.count > 0 { // Making species string
            var specsString = "Специи: "
            for i in 0..<orderItem.species.count{
                let value = orderItem.species[i]
                
                specsString.append(value["name"] as! String)
                
                if i != orderItem.species.count - 1{
                    specsString.append(", ")
                }
            }
            cell.speciesLbl.text = specsString
        } else {
            cell.speciesLbl.text = ""
        }
        if orderItem.sugar == 0{
            cell.sugarCountLbl.text = ""
        } else {
            if orderItem.sugar == floor(orderItem.sugar){
                cell.sugarCountLbl.text = "Сахар: \(Int(orderItem.sugar))"
            } else{
                cell.sugarCountLbl.text = "Сахар: \(orderItem.sugar)"
            }
        }
        
        return cell
    }

    @objc func deleteBtn(sender : UIButton){
        OrderData.orderList.remove(at: sender.tag)
        self.tableView.reloadData()
        updateLbls()
//        print(sender.tag)
    }
    @IBAction func makeOrderBtn(_ sender: Any) {
        if header != nil{
            if current_coffee_spot.is_active{
                if OrderData.getAllPrice() != 0{
                    performSegue(withIdentifier: "finishPostOrder", sender: self)
                } else{
                    self.view.makeToast("Заказ пуст")
                    print("ORDER IS EMPTY")
                }
            } else {
                self.view.makeToast("Кофейня закрыта")
                print("SPOT IS NOT ACTIVE")
            }
        } else {
            self.view.makeToast("Войдите чтоб заказать")
        }
        
    }
    
    func interface(){
        cornerRatio(view: elementsCountBG, ratio: elementsCountBG.frame.height / 2, shadow: false)
        cornerRatio(view: sliderViewStic, ratio: 2, shadow: true)
        cornerRatio(view: elementsCount, ratio: elementsCount.frame.height/2, shadow: false)
    }
    
    func updateLbls(){
        // Label count
        self.sumLbl.text = "Сумма: \(OrderData.getAllPrice()) грн"
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
