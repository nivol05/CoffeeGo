
import UIKit
import Alamofire
import AlamofireImage
import CarbonKit
import SeamlessSlideUpScrollView

class OrdersVC: UIViewController , CarbonTabSwipeNavigationDelegate {

    var menu : [[String: Any]] = [[String: Any]]()
    var productTypes : [[String: Any]] = [[String: Any]]()
    var tabs = [Int]()
    
    
    
    var items : [[Any]] = [[Any]]()
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var qwe : UIView!
    
    static var coffeeId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadManuLists()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        line = UIVisualEffectView(effect: blurEffect)
        
//        line.layer.cornerRadius = 4
//        line.layer.masksToBounds = false
        
        OrderData.orderList.removeAll()
        
        self.slideUpView.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let color = UIColor(red: 1, green: 0.585, blue: 0, alpha: 100)
//        UIApplication.shared.statusBarView?.backgroundColor = color
//        self.navigationController?.navigationBar.backgroundColor = color
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "Coffee")
        } else if index == 1 {
            return storyboard.instantiateViewController(withIdentifier: "Cake")
        } else if index == 2 {
            return storyboard.instantiateViewController(withIdentifier: "BottleWater")
        } else if index == 3 {
            return storyboard.instantiateViewController(withIdentifier: "Sandwich")
        } else if index == 4 {
            return storyboard.instantiateViewController(withIdentifier: "Pie")
        } else if index == 5 {
            return storyboard.instantiateViewController(withIdentifier: "Other")
        } else{
            return UIViewController()
        }
        
    }

    func downloadManuLists(){
        Alamofire.request("\(ORDER_URL)\(OrdersVC.coffeeId)").responseJSON { (response) in
            if let responseValue = response.result.value{
                self.menu = responseValue as! [[String : Any]]
                self.downloadProductTypes()
            }
            
        }
    }
    func downloadProductTypes(){
        Alamofire.request(PRODUCT_TYPES).responseJSON { (response) in
            if let responseValue = response.result.value{
                self.productTypes = responseValue as! [[String : Any]]
                self.setTabs()
            }
        }
    }
    
    func setTabs(){
        
        for i in 0..<menu.count{
            var here = false
            let potom = self.menu[i]["product_type"] as? Int
            for j in 0..<tabs.count{
                if potom == tabs[j]{
                    here = true

                    break
                }
            }
            if !here{
                tabs.append(potom!)
            }
        }
        tabs.sort()
        print(tabs.count)
        setPager()

    }


    
    func setPager(){
        var tabIcon = [UIImage]()
        User.i.removeAll()
        
        for i in 0..<tabs.count{
            
            if tabs[i] == 1 {
                User.i.append(getItems(type: 1))
                tabIcon.append(UIImage(named: "coffeTabIcon")!)
                
            } else if tabs[i] == 2 {
                User.i.append(getItems(type: 2))
                tabIcon.append(UIImage(named: "Deserts")!)
                
                
            } else if tabs[i] == 3 {
                User.i.append(getItems(type: 3))
                tabIcon.append(UIImage(named: "Drinks")!)
            } else if tabs[i] == 4 {
                User.i.append(getItems(type: 4))
                tabIcon.append(UIImage(named: "Sendwich")!)
            } else if tabs[i] == 7 {
                User.i.append(getItems(type: 7))
                tabIcon.append(UIImage(named: "Bakery")!)
            } else {
                User.i.append(getItems(type: 8))
                tabIcon.append(UIImage(named: "Other")!)
            }

        }
        
      
        
        let tabSwipe = CarbonTabSwipeNavigation(items: tabIcon , delegate: self)
        
        tabSwipe.setTabExtraWidth(30)
        tabSwipe.setTabBarHeight(56)
        tabSwipe.setSelectedColor(UIColor.black)
        tabSwipe.setIndicatorColor(UIColor.orange)
        tabSwipe.insert(intoRootViewController: self, andTargetView: qwe)
        tabSwipe.setNormalColor(UIColor.lightGray)

        
        
    }
    
    func getItems(type : Int) -> [Any]{
        var mas : [Any] = [Any]()
        var c = 0
        for i in 0..<self.menu.count{
            let potom = self.menu[i]["product_type"] as? Int
            if potom == type{
                mas.append(self.menu[i])
                c += 1
                CakeMenuList.kostil = i
            }
        }
        return mas
    }
    
    @IBAction func oggleSlideUpView(_ sender: AnyObject) {
        
        if self.slideUpView.isHidden {
            self.slideUpView.show(expandFull: false)
            slideUpView.isHidden = false
            tableView.reloadData()
            self.button.setTitle("Скрыть заказ", for: UIControlState())
        } else {
            self.slideUpView.hide()
            self.button.setTitle("Показать заказ", for: UIControlState())
        }
    }
}

extension OrdersVC : SeamlessSlideUpViewDelegate {
    
    func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = height
        tableView.reloadData()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
        self.button.setTitle("Скрыть заказ", for: UIControlState())
    }
    
    func slideUpViewDidAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }
    
    func slideUpViewWillDisappear(_ slideUpView: SeamlessSlideUpView) {
        self.bgBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
        self.button.setTitle("Показать заказ", for: UIControlState())
    }
    
    func slideUpViewDidDisappear(_ slideUpView: SeamlessSlideUpView) {
    }
    
    func slideUpViewDidDrag(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = min(height, self.slideUpView.bounds.height - self.slideUpView.topWindowHeight)
        self.view.layoutIfNeeded()
    }
    
    
}
extension OrdersVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderData.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let spots = OrderData.orderList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderList
        
        cell.nameLbl.text = spots.getName()
        cell.img.image = spots.getImage()
        cell.coffeePrice.text = spots.cup_size
        cell.coffeePrice.text = spots.product_price
//        cell.sugarCountLbl.text = "\(spots.getSugar())"
        
        return cell
    }
    
    
}



