
import UIKit
import Alamofire
import GoogleMaps


class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    
    var coffee : [[String: Any]] = [[String: Any]]()
    
    var test = Double()
    var test2 = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        let camera = GMSCameraPosition.camera(withLatitude: 50.45366301759805, longitude: 30.486644536805215, zoom: 12)
        let mapV = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapV
        
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
                    marker.position = CLLocationCoordinate2D(latitude: self.test, longitude: self.test2)
                    marker.map = mapV
                }
            }
        }
    }
}
