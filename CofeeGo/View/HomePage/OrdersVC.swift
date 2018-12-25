
import UIKit
import Alamofire
import AlamofireImage
//import CarbonKit
import SeamlessSlideUpScrollView
import XLPagerTabStrip
import Kingfisher

import CTSlidingUpPanel

class OrdersVC: ButtonBarPagerTabStripViewController,CTBottomSlideDelegate{
    
    var bottomController:CTBottomSlideController?;

    var tabs = [Int]()

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var MakeOrderBtn: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var spotAddressLbl: UILabel!
    @IBOutlet weak var companyLogoImg: UIImageView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parrent : UIView!
    
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        bottomBar()
    
        super.viewDidLoad()
        
        sliderView()
    }
    
    func bottomBar(){
        settings.style.buttonBarBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.selectedBarBackgroundColor = .white
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
    }
    
    func sliderView(){
        OrderData.orderList.removeAll()
        
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView, tabController: self.tabBarController!, navController: self.navigationController, visibleHeight: 20)
        
        bottomController?.delegate = self;
        bottomController?.set(table: OrderData.controller.tableView)
        
        OrderData.controller.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        cornerRatio(view: MakeOrderBtn, ratio: 5, shadow: true)
        cornerRatio(view: coffeeImg, ratio: 40/2, shadow: false)
        cornerRatio(view: bottomView, ratio: 20, shadow: false)
        
        let avatar_url = URL(string: current_coffee_net.logo_img)!
        
        coffeeImg.kf.setImage(with: avatar_url)
        companyNameLbl.text = current_coffee_net.name_other
        spotAddressLbl.text = current_coffee_spot.address
        OrderData.controller.limitLbl.text = "Лимит: \(current_coffee_spot.max_order_limit!) грн"
        OrderData.controller.sumLbl.text = "Сумма: \(0) грн"
    }
    
    @objc func toggleAction(sender:UIButton){
        bottomController?.expandPanel()
    }
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        bottomController?.viewWillTransition(to: size, with: coordinator)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPanelCollapse()
    {
        print("Collapsed");
    }
    func didPanelExpand(){
        print("Expanded")
    }
    func didPanelAnchor(){
        print("Anchored")
//      OrderData.controller.tableView.reloadData()
        
    }
    
    func didPanelMove(panelOffset: CGFloat)
        
    {
//        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let cell = Storyboard.instantiateViewController(withIdentifier: "OrderList") as! OrderListVC
        cornerRatio(view: bottomView, ratio: 15 - (panelOffset * 15), shadow: false)
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
            } else if i == 12{
                storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HotDrink"))
            }
        }
        
        return storyboard
    }
    
    
    @IBAction func oggleSlideUpView(_ sender: AnyObject) {
        
        if self.slideUpView.isHidden {
            self.slideUpView.show(expandFull: false)
            slideUpView.isHidden = false
            tableView.reloadData()
        } else {
            self.slideUpView.hide()
        }
    }
        
    @IBAction func togglePanel(_ sender: Any) {
        bottomController?.expandPanel()
    }
}

