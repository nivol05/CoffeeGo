
import UIKit
import MapKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView
import Kingfisher
import NVActivityIndicatorView

class MapCoffeeVC: UIViewController  , MKMapViewDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate , NVActivityIndicatorViewable, CLLocationManagerDelegate{
    
    var menu = [ElementProduct]()
    var productTypes : [[String: Any]] = [[String: Any]]()
    var tabs : [Int]!
    
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
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        clusterManager.setDelegate(self, mapDelegate: self)
        addCoffeeSpot()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
//        mapView.dequeueReusableAnnotationView(withIdentifier: "map")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("her")
        ImageCache.default.clearMemoryCache()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        
        // 4
        locationManager.startUpdatingLocation()
        
        
        //5
        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//        
//        // 7
////        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//        
//        // 8
//        locationManager.stopUpdatingLocation()
//    }

    
    
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
    
    func addCoffeeSpot(){
        let lat = Double(current_coffee_spot.lat)!
        let lng = Double(current_coffee_spot.lng)!
        
        let marker = GMSMarker()
        marker.icon = UIImage(named: "marker")
        
        let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), index: 0, marker : marker, active: !current_coffee_spot.is_closed)
        self.clusterManager.add(item)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 17)
        self.mapView.camera = camera
        self.mapView.delegate = self
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "map_style_dark", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.index!)")
            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            
            if header != nil{
                self.isOrderInProcess()
            } else {
                self.downloadManuLists()
            }
            
            
        } else {
            NSLog("Did tap a normal marker")
            let newCamera = GMSCameraPosition.camera(withTarget: marker.position,
                                                     zoom: mapView.camera.zoom + 1)
            mapView.animate(to: newCamera)
        }
        
        return true
    }
    
    func isOrderInProcess(){
        getActiveUserOrders(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orders = value as! [[String : Any]]
                if orders.count == 0{
                    //                    self.loadingView.isHidden = false
                    self.downloadManuLists()
                    print("USER CAN ORDER")
                } else{
                    self.view.makeToast("У вас есть незавершенный заказ")
                    print("USER HAS ORDERS")
                    self.stopAnimating()
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func downloadManuLists(){
        getProductsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.menu = setElementProductList(list: value as! [[String : Any]])
                self.downloadProductTypes()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    func downloadProductTypes(){
        getAllProductTypes().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.productTypes = value as! [[String : Any]]
                self.setTabs()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func setTabs(){
        tabs = []
        
        for i in 0..<menu.count{
            var here = false
            let potom = self.menu[i].product_type
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
        markerCLICK()
        
    }
    
    func markerCLICK(){
        
        if tabs.count != 0{
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
            
            controller.tabs = self.tabs
            
            //        let database = Database()
            //        database.deleteProduct()
            //        database.setProducts(products: menu)
            allSpotProducts = menu
            self.stopAnimating()
            self.navigationController?.pushViewController(controller, animated: true)
        } else{
            stopAnimating()
            self.view.makeToast("У данной кофейни нету продуктов для заказа")
        }
    }
}
