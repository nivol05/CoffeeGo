
import UIKit
import MapKit
import Alamofire

class MapCoffeeVC: UIViewController{

    
    //@IBOutlet weak var tableView: UITableView!
    
    var coffee : [[String: Any]] = [[String: Any]]()
    var LAT = Double()
    var LNG = Double()
    var coffeeAdress = [String]()
    var coffeeSpot = String()
    
    var pos = Double()
    
    var U = User()
    
    var CP : CoffeePage!
    var VC : ViewController!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        lineView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        lineView.layer.shadowOpacity = 1
        addCoffeeSpots()
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  //      return coffee.count
    //}
    
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let spots = coffee[indexPath.row]
        //let cell = tableView.dequeueReusableCell(withIdentifier: "adressList" , for : indexPath) as? CoffeeListOnMap
        //cell?.adreesCoffee.text = spots["address"] as? String
        //return cell!
    //}
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        self.hidesBottomBarWhenPushed = true
//    }
    
    func moveBack(){
        print("Zaebalsa")
        dismiss(animated: true, completion: nil)
    }
    
    
    func addCoffeeSpots(){
        Alamofire.request("http://138.68.79.98/api/customers/coffee_spots/?name=\(coffeeSpot)").responseJSON { (response) in
            
            if let responseValue = response.result.value{
                
                self.coffee = responseValue as! [[String : Any]]
                let countCoffee = self.coffee.count
                
                self.U.coffeeSpots = responseValue as! [[String : Any]]
                
                for i in 0...countCoffee - 1{
                    
                    var pinList = self.coffee[i]
                    
                    if let lat = pinList["lat"] as? String {
                        self.LAT = Double(lat)!
                    }
                    if let lng = pinList["lng"] as? String {
                        self.LNG = Double(lng)!
                    }
                    
                    let location = CLLocationCoordinate2DMake(self.LAT , self.LNG)
                    self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 1500, 1500), animated: true)
                    let pin = PinAnnotation(title: "\(self.LAT)" , subtitle: "\(self.LNG)" , coordinate: location)
                    self.mapView.addAnnotation(pin)
                    self.mapView.setCenter(location, animated: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = segue.destination as! SpotListVC
        cell.coffeeSpots = coffee
    }
}
