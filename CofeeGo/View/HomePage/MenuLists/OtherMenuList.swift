//
//  OtherMenuList.swift
//  CofeeGo
//
//  Created by Ni VoL on 16.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Kingfisher

class OtherMenuList: UIViewController , UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var test : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        test = User.i[5] as! [[String : Any]]
        print(test.count)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = test[indexPath.row]
        var avatar_url: URL
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherManu" , for : indexPath) as? OtherManu
        
        //Name
        cell?.nameLbl.text = data["name"] as? String
        
        //CoffeeImage
        avatar_url = URL(string: data["img"] as! String)!
        cell?.CoffeeImg.kf.setImage(with: avatar_url)
        
        //Price
        
        return cell!
    }

}
