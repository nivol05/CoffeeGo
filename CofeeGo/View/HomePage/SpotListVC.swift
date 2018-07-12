//
//  SpotListVC.swift
//  CofeeGo
//
//  Created by Ni VoL on 12.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class SpotListVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var tableView: MapParelavEffect!
    
    var coffeeSpots : [[String: Any]] = [[String: Any]]()
    
    var position = Bool()

    var U = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(coffeeSpots.count)
        tableView.delegate = self
        tableView.dataSource = self
        
        position = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeSpots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "adressList" , for : indexPath) as? CoffeeListOnMap
        let spots = coffeeSpots[indexPath.row]
//        print(spots["address"])
        cell?.adreesCoffee.text = spots["address"] as? String
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.hidesBottomBarWhenPushed = true
    }
    
    func moveBack(){
        performSegue(withIdentifier: "backMove", sender: self)
        print("Zaebalsa")
//        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func Test(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
