
import UIKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView
import Kingfisher

class MapVC: UIViewController, GMUClusterManagerDelegate,
GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    var coffee : [[String: Any]] = [[String: Any]]()
    var coffeeDots : [[String: Any]] = [[String: Any]]()
    
    @IBOutlet weak var coffeeLogo: UIImageView!
    var test = Double()
    var test2 = Double()
    
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       

       self.slideUpView.tableView = tableView
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        let camera = GMSCameraPosition.camera(withLatitude: 50.4316131848082, longitude: 30.5161834114672, zoom: 8)
        mapView.camera = camera
        mapView.delegate = self


        
        clusterManager.setDelegate(self, mapDelegate: self)

        
        Alamofire.request("http://138.68.79.98/api/customers/coffee_spots/").responseJSON { (response) in
            if let responseValue = response.result.value{

                self.coffee = responseValue as! [[String : Any]]
                let countCoffee = self.coffee.count
                print(countCoffee)

                for i in 0...countCoffee - 1{

                    var pinList = self.coffee[i]

                    if let lat = pinList["lat"] as? String {
                        print(Double(lat) ?? 0.0)
                        self.test = Double(lat)!
                    }
                    if let lng = pinList["lng"] as? String {
                        print(Double(lng) ?? 0.0)
                        self.test2 = Double(lng)!
                    }
                    
                    let marker = GMSMarker()
                    marker.icon = UIImage(named: "marker")
                    
                    let item = POIItem(position: CLLocationCoordinate2DMake(self.test, self.test2), index: i, marker : marker)
                    self.clusterManager.add(item)
                    
                }
            }
        }
        
        Alamofire.request(LIST_COFFEE_URL).responseJSON { (response) in
            
            if let responseValue = response.result.value{
                self.coffeeDots = responseValue as! [[String : Any]]
            }
        }
        
        clusterManager.cluster()

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {



        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.index)")
            let coffeePlace = coffeeDots[poiItem.index]
            let avatar_url : URL
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17)
            self.mapView.animate(to: camera)
            self.mapView.delegate = self
            if self.slideUpView.isHidden {
                self.slideUpView.show(expandFull: false)
                slideUpView.isHidden = false
                
                avatar_url = URL(string: coffeePlace["logo_img"] as! String)!
                coffeeLogo.kf.setImage(with: avatar_url)
                
                
            }
        } else {
            NSLog("Did tap a normal marker")
            let newCamera = GMSCameraPosition.camera(withTarget: marker.position,
                                                     zoom: mapView.camera.zoom + 1)
//            let update = GMSCameraUpdate.setCamera(newCamera)
//            mapView.moveCamera(update)
            mapView.animate(to: newCamera)
        }
        return true
    }
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster clusteritem: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: clusteritem.position,
                                                           zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        print("TYT")
        mapView.moveCamera(update)
    }

}
extension MapVC : SeamlessSlideUpViewDelegate {
    
    func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = height
        tableView.reloadData()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
    }
    
    func slideUpViewDidAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }
    
    func slideUpViewWillDisappear(_ slideUpView: SeamlessSlideUpView) {
        self.bgBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
    }
    
    func slideUpViewDidDisappear(_ slideUpView: SeamlessSlideUpView) {
    }
    
    func slideUpViewDidDrag(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = min(height, self.slideUpView.bounds.height - self.slideUpView.topWindowHeight)
        self.view.layoutIfNeeded()
    }
    
}
//extension MapVC : UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return coffee.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let spots = coffee[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CoffeeListOnMap
//
//        cell.adreesCoffee.text = spots["address"] as? String
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let coffeeidList = coffee[indexPath.row]
//        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let cell = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
//        cell.coffeeId = coffeeidList["id"] as! Int
//        self.navigationController?.pushViewController(cell, animated: true)
//    }
//}

