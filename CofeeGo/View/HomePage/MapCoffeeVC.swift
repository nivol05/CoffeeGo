
import UIKit
import MapKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView
import Kingfisher

class MapCoffeeVC: UIViewController  , MKMapViewDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate{
    
    var coffee = [ElementCoffeeSpot]()
    var menu = [ElementProduct]()
    var productTypes : [[String: Any]] = [[String: Any]]()
    var tabs : [Int]!
    var activeSpot = false
    
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
        
        
        addCoffeeSpots()

        
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
        getCoffeeSpotsForNet(company: current_coffee_net.name).responseJSON { (response) in
            
            if let responseValue = response.result.value{
                
                self.coffee = setElementCoffeeSpotList(list: responseValue as! [[String : Any]])
                if self.coffee.count > 0{
                    for i in 0..<self.coffee.count{
                        
                        let spot = self.coffee[i]
                        
                        let lat = Double(spot.lat)!
                        let lng = Double(spot.lng)!
                        
                        let marker = GMSMarker()
                        marker.icon = UIImage(named: "marker")
                        
                        let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), index: i, marker : marker, active: spot.is_active)
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
            
             let spot = coffee[poiItem.index!]
            activeSpot = spot.is_active
            self.downloadManuLists(spot: spot)

        } else {
            NSLog("Did tap a normal marker")
            let newCamera = GMSCameraPosition.camera(withTarget: marker.position,
                                                     zoom: mapView.camera.zoom + 1)
            mapView.animate(to: newCamera)
        }
        
        return true
    }
    
    func downloadManuLists(spot : ElementCoffeeSpot){
        getProductsForSpot(spotId: "\(spot.id!)").responseJSON { (response) in
            if let responseValue = response.result.value{
                self.menu = setElementProductList(list: responseValue as! [[String : Any]])
                self.downloadProductTypes(spot: spot)
            }
            
        }
    }
    func downloadProductTypes(spot : ElementCoffeeSpot){
        getAllProductTypes().responseJSON { (response) in
            if let responseValue = response.result.value{
                self.productTypes = responseValue as! [[String : Any]]
                self.setTabs(spot: spot)
            }
        }
    }
    
    func setTabs(spot : ElementCoffeeSpot){
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
        markerCLICK(spot: spot)
        
    }
    
    func markerCLICK(spot : ElementCoffeeSpot){
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
        
        controller.tabs = self.tabs
        controller.activeSpot = self.activeSpot
        
//        let database = Database()
//        database.deleteProduct()
//        database.setProducts(products: menu)
        allSpotProducts = menu
        
        current_coffee_spot = spot

        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
