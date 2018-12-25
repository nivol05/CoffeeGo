//
//  AllCommentsVC.swift
//  CofeeGo
//
//  Created by NI Vol on 11/5/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class AllCommentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments = [ElementComment]()
    var users = [ElementUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        PageCoffee.LoadViewActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsCell", for: indexPath) as! AllCommentsCell
        let commentElem = comments[indexPath.row]
        cell.commentLbl.text = commentElem.comment
        cell.userNameLbl.text = getUserById(userId:  commentElem.user!)?.first_name
        cell.starsView.rating = commentElem.stars
        cell.dateLbl.text = commentElem.date!
        return cell
    }
    
    func getUserById(userId: Int) -> ElementUser?{
        for user in users{
            if user.id == userId{
                return user
            }
        }
        return nil
    }
    

}
