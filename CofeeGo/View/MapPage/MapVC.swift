
import UIKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView

class MapVC: UIViewController, GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var coffee : [[String: Any]] = [[String: Any]]()
    
    var test = Double()
    var test2 = Double()
    
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
       self.slideUpView.tableView = tableView
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        
        let camera = GMSCameraPosition.camera(withLatitude: 50.4316131848082, longitude: 30.5161834114672, zoom: 13)
        mapView.camera = camera
        mapView.delegate = self

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
                    marker.icon = GMSMarker.markerImage(with: .black)
//                    marker.icon = UIImage(named: "marker")
                    marker.position = CLLocationCoordinate2D(latitude: self.test, longitude: self.test2)
                    marker.title = "\(self.test)"
                    marker.map = self.mapView
                
                }
            }
        }
    }
//        let myMapView: GMSMapView = {
//            GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
//            let v=GMSMapView()
//            v.translatesAutoresizingMaskIntoConstraints=false
//            return v
//        }()
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17)
        self.mapView.camera = camera
        self.mapView.delegate = self
        
        if self.slideUpView.isHidden {
            self.slideUpView.show(expandFull: false)
            slideUpView.isHidden = false

        } 
        
        return true
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

