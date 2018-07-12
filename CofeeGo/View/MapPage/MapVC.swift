
import UIKit
import Alamofire
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var coffee : [[String: Any]] = [[String: Any]]()
    
    var test = Double()
    var test2 = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2DMake(50.45366301759805, 30.486644536805215)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 1500, 1500), animated: true)
        let pin = PinAnnotation(title: "", subtitle: "", coordinate: location)
        mapView.addAnnotation(pin)
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
                    
                    let location = CLLocationCoordinate2DMake(self.test , self.test2)
                    self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 1500, 1500), animated: true)
                    let pin = PinAnnotation(title: "\(self.test)" , subtitle: "\(self.test2)" , coordinate: location)
                    self.mapView.addAnnotation(pin)
                }
            }
        }
    }
}
