
import UIKit
import MapKit
import Alamofire
import SeamlessSlideUpScrollView

class MapCoffeeVC: UIViewController  , MKMapViewDelegate{
    
    var coffee : [[String: Any]] = [[String: Any]]()
    var LAT = Double()
    var LNG = Double()
    var coffeeAdress = [String]()
    var coffeeSpot = String()
    
    var pos = Double()
    
    var CP : CoffeePage!
    var VC : ViewController!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCoffeeSpots()
        lineView.layer.cornerRadius = 4
        self.slideUpView.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        let screenWidth = UIScreen.main.bounds.size.height
        slideUpView.delegate = self
        slideUpView.topWindowHeight = screenWidth / 2
        print(slideUpView.topWindowHeight)
        mapView.dequeueReusableAnnotationView(withIdentifier: "map")
    }
    

//    func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        if annotation is MKUserLocation{
//            return nil
//        }
//        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "map")
////        let anotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "map")
//        annotationView.pinTintColor = UIColor.black
//        annotationView.canShowCallout = true
//        return annotationView
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
    
    func addCoffeeSpots(){
        Alamofire.request("http://138.68.79.98/api/customers/coffee_spots/?name=\(coffeeSpot)").responseJSON { (response) in
            
            print("http://138.68.79.98/api/customers/coffee_spots/?name=\(self.coffeeSpot)")
            if let responseValue = response.result.value{
                
                self.coffee = responseValue as! [[String : Any]]
                let countCoffee = self.coffee.count
                
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
                    self.mapView.delegate = self
                }
            }
        }
    }
}
extension MapCoffeeVC : SeamlessSlideUpViewDelegate {

    func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = height
        tableView.reloadData()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() })
        self.button.setTitle("Скрыть список", for: UIControlState())
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
        cell.coffeeId = coffeeidList["id"] as! Int
        self.navigationController?.pushViewController(cell, animated: true)
    }
}
