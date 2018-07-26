

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD

class CoffeePage: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var VC : ViewController!
    var MCVC : MapCoffeeVC!
    
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    
    var name = String()
    var imgUrl = String()
    var logo = String()
    
    var test2 = Double()
    
    var plis = Int()
    
    var token = String()
    
    var comments: [[String: Any]] = [[String: Any]]()
    var users : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        spinner(shouldSpin: true)
        LoadContent()
        
        //selectBtn.layer.cornerRadius = 7
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comments" , for : indexPath) as? CommentTable
        
        if comments.count > 0{
            let commentList = comments[indexPath.row]
            
            
            cell?.commentLbl?.text = (commentList["comment"] as? String) ?? ""
            
            if let stars = commentList["stars"] as? Double {
               self.test2 = stars
            }
            
            cell?.rateLbl?.text = ("Rate \(test2)")
            
            cell?.dataLbl?.text = (commentList["date"] as? String) ?? ""
            
            Alamofire.request(USER_URL).responseJSON { (response) in
                if let responseValue = response.result.value{
                    self.users = responseValue as! [[String : Any]]
                    self.plis = self.users.count
                    
                    for i in 0...self.plis{
                        let user = self.users[i]
                        if user["id"] as? Int == commentList["user"] as? Int{
                            cell?.userNameLbl.text = "\(String(describing: user["first_name"]!))  \(String(describing: user["last_name"]!))"
                            break
                        }
                    }
                }
            }
        }
        
        return cell!
    }
    
    @IBAction func selectCoffeeBtn(_ sender: Any) {
//        performSegue(withIdentifier: "CoffeeToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = segue.destination as! MapCoffeeVC
        cell.coffeeSpot = name
    }
    func LoadContent(){
        
        nameLbl.text = name
        
        Alamofire.request(logo).responseImage(completionHandler: {(response) in
            if let image = response.result.value{
                self.logoImg.image = image
            }
        })
        
        Alamofire.request(imgUrl).responseImage(completionHandler: {(response) in
            if let image = response.result.value{
                self.coffeeImg.image = image
            }
        })
        
        let commentUrl = "\(COMMENTS_URL)\(name)"
        
        let params : HTTPHeaders = [
            "Authorization": token
        ]
        
        Alamofire.request(commentUrl, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if let responseValue = response.result.value{
                self.comments = responseValue as! [[String : Any]]
                self.tableView?.reloadData()
                self.spinner(shouldSpin: false)
            }
        }
    }
    func spinner(shouldSpin status: Bool){
        if status == true{
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
            self.tableView.isHidden = false
        }
    }
    @IBAction func moreTextBtn(_ sender: Any) {
        print(infoLbl.numberOfLines)
        infoLbl.numberOfLines = 0
        print(infoLbl.numberOfLines)
    }
}
