
import UIKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView
import Kingfisher
import Cosmos

class MapVC: UIViewController, GMUClusterManagerDelegate,
GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var coffeeLogo: UIImageView!
    @IBOutlet weak var coffeeName: UILabel!
    @IBOutlet weak var coffeeStars: CosmosView!
    @IBOutlet weak var coffeeAddress: UILabel!
    @IBOutlet weak var coffeeDistance: UILabel!
    @IBOutlet weak var coffeeWorkTime: UILabel!
    
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var botomView: SeamlessSlideUpScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
       self.slideUpView.scrollView = botomView
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        let camera = GMSCameraPosition.camera(withLatitude: 50.4316131848082, longitude: 30.5161834114672, zoom: 10)
        mapView.camera = camera
        mapView.delegate = self

        if allCoffeeSpots == nil{
            getSpots()
        } else {
            setMarkers()
        }
        clusterManager.setDelegate(self, mapDelegate: self)

        
        clusterManager.cluster()

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        if let poiItem = marker.userData as? POIItem {
            let spot = allCoffeeSpots[poiItem.index]
            if allCoffeeNets == nil{
                getAllCoffeeNets(spot: spot, marker: marker)
            } else {
                markerClick(spot: spot, marker: marker, coffeeNetIndex: getCoffeeNetIndex(spot: spot, marker: marker))
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
    
    @IBAction func toOrder(_ sender: Any) {
        
    }
    
    
    func getSpots(){
        getCoffeeSpots().responseJSON { (response) in
            if let responseValue = response.result.value{
                allCoffeeSpots = setElementCoffeeSpotList(list: responseValue as! [[String : Any]])
                self.setMarkers()
            }
        }
    }
    
    func setMarkers(){
        for i in 0..<allCoffeeSpots.count{
            
            let spot = allCoffeeSpots[i]
            
            let lat = Double(spot.lat)!
            let lng = Double(spot.lng)!
            
            let marker = GMSMarker()
            marker.icon = UIImage(named: "marker")
            
            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), index: i, marker : marker, active: spot.is_active)
            self.clusterManager.add(item)
            
        }
    }

    func getCoffeeNetIndex(spot: ElementCoffeeSpot, marker: GMSMarker) -> Int{
        var index = 0
        
        for x in 0..<allCoffeeNets.count{
            let elem = allCoffeeNets[x]
            if elem.id == spot.company{
                index = x
                break
            }
        }
        return index
    }
    
    func markerClick(spot: ElementCoffeeSpot, marker: GMSMarker, coffeeNetIndex: Int){
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17)
        self.mapView.animate(to: camera)
        self.mapView.delegate = self
        
        let company = allCoffeeNets[coffeeNetIndex]
        
        if self.slideUpView.isHidden {
            self.slideUpView.show(expandFull: false)
            slideUpView.isHidden = false
            
            coffeeLogo.kf.setImage(with: URL(string: company.logo_img)!)
            coffeeImg.kf.setImage(with: URL(string: company.img)!)
            coffeeName.text = company.name_other!
            coffeeStars.rating = company.stars!
            coffeeAddress.text = spot.address!
            coffeeDistance.text = getDistance(latF: 50.4316131848082, lngF: 30.5161834114672,
                                              latS: Double(spot.lat)!, lngS: Double(spot.lng)!)
            coffeeWorkTime.text = "Время работы -  \(spot.time_start!) : \(spot.time_finish!)"
            
        }
    }
    
    func getAllCoffeeNets(spot: ElementCoffeeSpot, marker: GMSMarker){
        getCoffeeNets().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                allCoffeeNets = setElementCoffeeNetList(list: value as! [[String : Any]])
                self.markerClick(spot: spot, marker: marker, coffeeNetIndex: self.getCoffeeNetIndex(spot: spot, marker: marker))
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getDistance(latF: Double, lngF: Double, latS: Double, lngS: Double) -> String{
        let coordinateF = CLLocation(latitude: latF, longitude: lngF)
        let coordinateS = CLLocation(latitude: latS, longitude: lngS)
        let distanceInMeters = coordinateF.distance(from: coordinateS) / 1000
        return "\(distanceInMeters.rounded(toPlaces: 2)) км"
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

