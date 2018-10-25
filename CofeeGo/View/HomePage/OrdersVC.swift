
import UIKit
import Alamofire
import AlamofireImage
//import CarbonKit
import SeamlessSlideUpScrollView
import XLPagerTabStrip

class OrdersVC: ButtonBarPagerTabStripViewController {

    var tabs = [Int]()
  
    
    var items : [[Any]] = [[Any]]()
    
    @IBOutlet weak var MakeOrderBtn: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var qwe : UIView!
    
    
    override func viewDidLoad() {
        
        
        
        settings.style.buttonBarBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .systemFont(ofSize: 18, weight: UIFont.Weight.light)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = UIColor.white
        }
        
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        cornerRatio(view: MakeOrderBtn, ratio: 5, shadow: true)
        
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
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var storyboard = [UIViewController]()
        for i in tabs{
            if i == 1{
                storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Coffee"))
            } else if i == 2{
                storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Cake"))
            } else if i == 9{
                storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottleWater"))
            } else if i == 10{
                storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Pie"))
            } else if i == 11{
                storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Other"))
            }
        }
        
        print(storyboard)
        return storyboard
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
        
        let orderItem = OrderData.orderList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderList
        
        cell.nameLbl.text = orderItem.product_name
        cell.img.image = orderItem.imageUrl
        cell.coffeePrice.text = orderItem.cup_size
        cell.priceOrderDone.text = "\(orderItem.getProductPrice()) грн"
        
        var syrupsText = String()
        for i in 0..<orderItem.syrups.count{
            let value = orderItem.syrups[i]
            
            syrupsText.append(value["name"] as! String)
            
            if i != orderItem.syrups.count - 1{
                syrupsText.append(", ")
            }
        }
        cell.additionalLbl.text = syrupsText
//        cell.sugarCountLbl.text = "\(spots.getSugar())"
        
        return cell
    }
    
    
}



