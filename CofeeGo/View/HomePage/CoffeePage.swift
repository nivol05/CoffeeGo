

import UIKit
import Alamofire
import AlamofireImage
import SVProgressHUD
import Cosmos
import HCSStarRatingView
import Tamamushi

class CoffeePage: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var VC : ViewController!
    var MCVC : MapCoffeeVC!
    
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var lblReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var rateView: CosmosView!
    
    var isLabelAtMaxHeight = Bool()
    var name = String()
    var imgUrl = String()
    var logo = String()
    
    var test2 = Double()
    var st = Double()
    var alpha = CGFloat(0.0)
    
    var plis = Int()
    
    var token = String()
    
    var comments: [[String: Any]] = [[String: Any]]()
    var users : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        spinner(shouldSpin: true)
        LoadContent()
        
        TMGradientNavigationBar().setGradientColorOnNavigationBar(bar: (self.navigationController?.navigationBar)!, direction: .vertical, typeName: "Facebook Messenger")
        
        self.tableView.contentInset.bottom = selectBtn.frame.height
        
//        rateView.value = CGFloat(st)
        rateLbl.text = "\(st)"
        rateView.rating = st
        //selectBtn.layer.cornerRadius = 7
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let color = UIColor(red: 1, green: 0.585, blue: 0, alpha: alpha)
//        UIApplication.shared.statusBarView?.backgroundColor = color
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.backgroundColor = color
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
//                cell?.rateInComment.rating = stars
            }
            
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
        } else {
            print("NEMECOMENTOV")
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var offset = scrollView.contentOffset.y
        
//        if offset < -1 {
//            coffeeImg.contentMode = .scaleAspectFit
            
            
//
//            offset = 1
//            alpha = offset
//            let colorWithOffset = UIColor(red: 1, green: 0.585, blue: 0, alpha: offset)
//            self.navigationController?.navigationBar.backgroundColor = colorWithOffset
//            UIApplication.shared.statusBarView?.backgroundColor = colorWithOffset
//        } else {
//            coffeeImg.contentMode = .scaleToFill
//            alpha = offset
//            let colorWithOffset = UIColor(red: 1, green: 0.585, blue: 0, alpha: offset)
//            self.navigationController?.navigationBar.backgroundColor = colorWithOffset
//            UIApplication.shared.statusBarView?.backgroundColor = colorWithOffset
//        }
    }

    @IBAction func selectCoffeeBtn(_ sender: Any) {
//        performSegue(withIdentifier: "CoffeeToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let cell = segue.destination as! MapCoffeeVC
//        print("TYT")
//        let color = UIColor(red: 1, green: 0.585, blue: 0, alpha: 0)
//        UIApplication.shared.statusBarView?.backgroundColor = color
//        self.navigationController?.navigationBar.backgroundColor = color
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
    
    func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.font = font
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.sizeToFit()
        
        return lbl.frame.size.height
    }
    
    @IBAction func btnReadMore(_ sender: Any) {
        if isLabelAtMaxHeight {
            btnReadMore.setTitle("Read more", for: .normal)
            isLabelAtMaxHeight = false
            lblReviewHeight.constant = 93
        }
        else {
            btnReadMore.setTitle("Read less", for: .normal)
            isLabelAtMaxHeight = true
            lblReviewHeight.constant = getLabelHeight(text: infoLbl.text!, width: view.bounds.width, font: infoLbl.font)
            
        }
        
    }
    @IBAction func moreTextBtn(_ sender: Any) {
        print(infoLbl.numberOfLines)
        infoLbl.numberOfLines = 0
        print(infoLbl.numberOfLines)
    }
}
