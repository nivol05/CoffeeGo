//
//  CoffeeMenuList.swift
//  CofeeGo
//
//  Created by Ni VoL on 16.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Kingfisher

class CoffeeMenuList: UIViewController , UITableViewDataSource, UITableViewDelegate {

    var t_count:Int = 0
    var lastCell: DropDownCell = DropDownCell()
    var button_tag : Int = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var test : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test = User.i[0] as! [[String : Any]]
        print(test.count)
        print(test)
//        tableView = UITableView(frame: view.frame)
//        tableView.layer.frame.size.height = view.frame.height * 1.5
//        tableView.frame.origin.y += 125
        tableView.register(UINib(nibName: "DropDownCell", bundle: nil), forCellReuseIdentifier: "CoffeeManu")

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.allowsSelection = false
//        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == button_tag {
            return 365
        } else {
            return 140
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeManu" , for : indexPath) as! DropDownCell
        if indexPath.row == button_tag {
            print("last cell is seen!!")
//            self.tableView.beginUpdates()
            
            let previousCellTag = button_tag
            
            if lastCell.cellExists {
                print("per")
                self.lastCell.animate(duration: 0.3, c: {
                    self.view.layoutIfNeeded()
                })
                
                if indexPath.row == button_tag {
                    print("vtor")
                    button_tag = -1
                    lastCell = DropDownCell()
                }

            }
            
            if indexPath.row != previousCellTag {
                button_tag = indexPath.row
                print("tre")
                
                
                lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! DropDownCell

                self.lastCell.animate(duration: 0.3, c: {
                    self.view.layoutIfNeeded()
                })
                
            }
            
                self.tableView.endUpdates()
            self.tableView.beginUpdates()
//            self.tableView.reloadData()
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = test[indexPath.row]
        var avatar_url: URL
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeManu" , for : indexPath) as! DropDownCell
        
        if !cell.cellExists {
            
            //Name
            cell.nameLbl.text = data["name"] as? String
            
            //CoffeeImage
            avatar_url = URL(string: data["img"] as! String)!
            cell.CoffeeImg.kf.setImage(with: avatar_url)
            
            //Price
//            cell.open.tag = t_count
            
            cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
            t_count += 1
            cell.cellExists = true
            
            cell.open.tag = indexPath.row
            
        }
        else {
            
            cell.open.tag = indexPath.row
        
        }

        
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
            
        
        return cell
    }
    
    @objc func cellOpened(sender:UIButton) {
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = DropDownCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! DropDownCell
//            
//            lastCell.stuffView.isHidden = false
//            lastCell.stuffView.alpha = 1
            self.lastCell.animate(duration: 0.3, c: {
                self.view.layoutIfNeeded()
            })
            
        }
        self.tableView.endUpdates()
    }

}
