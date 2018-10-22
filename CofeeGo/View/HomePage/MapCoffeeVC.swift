
import UIKit
import MapKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView
import Kingfisher

class MapCoffeeVC: UIViewController  , MKMapViewDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate{
    
    var coffee : [[String: Any]] = [[String: Any]]()
    var LAT = Double()
    var LNG = Double()
    var coffeeAdress = [String]()
    var coffeeSpot = String()
    var menu : [[String: Any]] = [[String: Any]]()
    var productTypes : [[String: Any]] = [[String: Any]]()
    var tabs : [Int]!
    
    var pos = Double()
    
    var CP : CoffeePage!
    var VC : ViewController!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    @IBOutlet var BgList: UIView!
    
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        let camera = GMSCameraPosition.camera(withLatitude: 50.44901331994515, longitude: 30.525069320831903, zoom: 13)
        
        
        mapView.camera = camera
        mapView.delegate = self
        clusterManager.setDelegate(self, mapDelegate: self)
        
        coffeeSpot = User.name
        
        addCoffeeSpots()
        lineView.layer.cornerRadius = 4
        self.slideUpView.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        let screenWidth = UIScreen.main.bounds.size.height
        slideUpView.delegate = self
        slideUpView.topWindowHeight = screenWidth / 2
        print(slideUpView.topWindowHeight)

        
//        mapView.dequeueReusableAnnotationView(withIdentifier: "map")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("her")
        ImageCache.default.clearMemoryCache()
        
    }

    
    
    @IBAction func oggleSlideUpView(_ sender: AnyObject) {
        
        if self.slideUpView.isHidden {
            self.slideUpView.show(expandFull: false)
            slideUpView.isHidden = false
            self.button.setTitle("Скрыть список", for: UIControlState())
        } else {
            self.slideUpView.hide()
            self.button.setTitle("Показать список", for: UIControlState())
        }
    }
    
    func addCoffeeSpots(){
        getCoffeeSpotsForNet(company: coffeeSpot).responseJSON { (response) in
            
            print("http://138.68.79.98/api/customers/coffee_spots/?name=\(self.coffeeSpot)")
            if let responseValue = response.result.value{
                
                self.coffee = responseValue as! [[String : Any]]
                let countCoffee = self.coffee.count
                if countCoffee > 0{
                    for i in 0...countCoffee - 1{
                        
                        var pinList = self.coffee[i]
                        
                        if let lat = pinList["lat"] as? String {
                            self.LAT = Double(lat)!
                        }
                        if let lng = pinList["lng"] as? String {
                            self.LNG = Double(lng)!
                        }
                        
                        
                        let marker = GMSMarker()
                        marker.icon = UIImage(named: "marker")
                        
                        let item = POIItem(position: CLLocationCoordinate2DMake(self.LAT, self.LNG), index: i, marker : marker)
                        self.clusterManager.add(item)
//                        let marker = GMSMarker()
//                        marker.icon = GMSMarker.markerImage(with: .black)
//                        marker.position = CLLocationCoordinate2D(latitude: self.LAT, longitude: self.LNG)
//                        marker.map = self.mapView
                    }
                }

            }
        }
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.index!)")
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17)
            self.mapView.camera = camera
            self.mapView.delegate = self
            
             let coffeeidList = coffee[poiItem.index!]
            self.downloadManuLists(coffeeidList: coffeeidList)

        } else {
            NSLog("Did tap a normal marker")
            let newCamera = GMSCameraPosition.camera(withTarget: marker.position,
                                                     zoom: mapView.camera.zoom + 1)
            mapView.animate(to: newCamera)
        }
        
        return true
    }
    
    func downloadManuLists(coffeeidList : [String : Any]){
        getProductsForSpot(spotId: "\(coffeeidList["id"]!)").responseJSON { (response) in
            if let responseValue = response.result.value{
                self.menu = responseValue as! [[String : Any]]
                self.downloadProductTypes(coffeeidList: coffeeidList)
            }
            
        }
    }
    func downloadProductTypes(coffeeidList : [String : Any]){
        getAllProductTypes().responseJSON { (response) in
            if let responseValue = response.result.value{
                self.productTypes = responseValue as! [[String : Any]]
                self.setTabs(coffeeidList: coffeeidList)
            }
        }
    }
    
    func setTabs(coffeeidList : [String : Any]){
        tabs = []
        
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
        markerCLICK(coffeeidList: coffeeidList)
        
    }
    
    func markerCLICK(coffeeidList : [String : Any]){
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
        
        cell.tabs = self.tabs
        
        let database = Database()
        database.deleteProduct()
        database.setProducts(products: menu)
        
        

        OrdersVC.coffeeId = coffeeidList["id"] as! Int
        self.navigationController?.pushViewController(cell, animated: true)
        
    }
}



extension MapCoffeeVC : SeamlessSlideUpViewDelegate {

    func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = height
        tableView.reloadData()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
        self.button.setTitle("Скрыть список", for: UIControlState())
        let blurEff = UIBlurEffect(style: UIBlurEffectStyle.light)
        let bl = UIVisualEffectView(effect: blurEff)
        bl.frame = blurImage.bounds
        blurImage.addSubview(bl)
    }

    func slideUpViewDidAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }

    func slideUpViewWillDisappear(_ slideUpView: SeamlessSlideUpView) {
        self.bgBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
        self.button.setTitle("Показать список", for: UIControlState())
    }

    func slideUpViewDidDisappear(_ slideUpView: SeamlessSlideUpView) {
    }

    func slideUpViewDidDrag(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = min(height, self.slideUpView.bounds.height - self.slideUpView.topWindowHeight)
        self.view.layoutIfNeeded()
    }

}
extension MapCoffeeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffee.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let spots = coffee[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CoffeeListOnMap
        
        cell.adreesCoffee.text = spots["address"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coffeeidList = coffee[indexPath.row]
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
        OrdersVC.coffeeId = coffeeidList["id"] as! Int
        self.navigationController?.pushViewController(cell, animated: true)
    }
}
