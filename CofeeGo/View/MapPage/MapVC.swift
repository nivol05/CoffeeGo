
import UIKit
import Alamofire
import GoogleMaps
import SeamlessSlideUpScrollView
import Kingfisher
import Cosmos
import CTSlidingUpPanel
import NVActivityIndicatorView

class MapVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, GMUClusterManagerDelegate,
GMSMapViewDelegate,CTBottomSlideDelegate , NVActivityIndicatorViewable, CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var sliderStick: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    var bottomController:CTBottomSlideController?;
    
    @IBOutlet weak var loadingCommentsView: UIView!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var coffeeImg: UIImageView!
    @IBOutlet weak var coffeeLogo: UIImageView!
    @IBOutlet weak var coffeeName: UILabel!
    @IBOutlet weak var coffeeStars: CosmosView!
    @IBOutlet weak var coffeeAddress: UILabel!
    @IBOutlet weak var coffeeDistance: UILabel!
    @IBOutlet weak var coffeeWorkTime: UILabel!
    @IBOutlet weak var parrent: UIView!
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var heightConstr: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var emptyView: UIView!
    
    var menu = [ElementProduct]()
    var productTypes : [[String: Any]] = [[String: Any]]()
    var tabs : [Int]!
    var comments = [ElementComment]()
    var users = [ElementUser]()
    
    private let locationManager = CLLocationManager()
    
    //creating a marker view
    let markerView = UIImageView(image: UIImage(named: "map_marker")!.withRenderingMode(.alwaysTemplate))
    
    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var botomView: SeamlessSlideUpScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
        
        views()
        marker()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        parrent.isHidden = true
        bottomController?.hidePanel()
    }
    
    func didPanelCollapse()
    {
        print("Collapsed");
        

    }
    func didPanelMove(panelOffset: CGFloat) {
        cornerRatio(view: parrent, ratio: 20 - (panelOffset * 20), shadow: false)
    }
    func didPanelExpand(){
        print("Expanded")
    }
    func didPanelAnchor(){
        print("Anchored")
        //      OrderData.controller.tableView.reloadData()
        
    }
    
    
    // pass a param to describe the state change, an animated flag and a completion block matching UIView animations completion
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if comments.count > 5{ // CHANGED
            collectionView.isHidden = false
            print("N EMP IN COL VIEW")

            return 5
        }
        if comments.count == 0{
            
            print("EMP IN COL VIEW")
            self.collectionView.isHidden = true
            self.emptyView.isHidden = false
        }
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        return CGSize(width: screenWidth - 20, height: screenHeight * 0.22)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Comments", for: indexPath) as! CommentsCell
        
            let commentElem = comments[indexPath.row]
            //            cornerRatio(view: cell.BGView)
            cell.BGView.layer.cornerRadius = 5
            cell.BGView.clipsToBounds = true
            //            cell.corner()
            
            cell.commentLbl.text = commentElem.comment
            cell.rateInComments.rating = commentElem.stars
            
            //            if let stars = commentList["stars"] as? Double {
            //                cell?.rateInComment.rating = stars
            //            }
            
            cell.dateLbl?.text = commentElem.date
            
            for i in 0..<self.users.count{
                let user = self.users[i]
                if user.id == commentElem.user{
                    cell.userNameLbl.text = "\(user.first_name!)"
                    break
                }
            }
        return cell
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
    
    func views(){
        loadingCommentsView.isHidden = false
        
        cornerRatio(view: coffeeLogo, ratio: coffeeLogo.frame.height/2, shadow: false)
        cornerRatio(view: sliderStick, ratio: 2, shadow: false)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func marker(){
        
        buttonBottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
        parrent.isHidden = true
        bottomController = CTBottomSlideController(topConstraint: topConstraint, heightConstraint: heightConstr, parent: view, bottomView: parrent, tabController: self.tabBarController!, navController: self.navigationController, visibleHeight: 30)
        bottomController?.delegate = self;
        self.slideUpView.scrollView = botomView
        GMSServices.provideAPIKey("AIzaSyC-25GtNVS-4kiObXxAXaHdGby0yDhawLA")
        
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [99], backgroundImages: [UIImage(named: "map_cluster")!])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        
        let camera = GMSCameraPosition.camera(withLatitude: 50.4316131848082, longitude: 30.5161834114672, zoom: 10)
        mapView.camera = camera
        mapView.delegate = self
        
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
        
        if allCoffeeSpots == nil{
            getSpots()
        } else {
            setMarkers()
        }
        clusterManager.setDelegate(self, mapDelegate: self)
        clusterManager.cluster()
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        fadeView(view: loadingCommentsView, delay: 0.2, isHiden: false)
        if let poiItem = marker.userData as? POIItem {
            let spot = getActiveSpots()[poiItem.index]
            if allCoffeeNets == nil{
                getAllCoffeeNets(spot: spot, marker: marker)
            } else {
                markerClick(spot: spot, marker: marker)
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
            
            switch response.result {
            case .success(let value):
                allCoffeeSpots = setElementCoffeeSpotList(list: value as! [[String : Any]])
                self.setMarkers()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func setMarkers(){
        for i in 0..<getActiveSpots().count{
            
            let spot = getActiveSpots()[i]
            
            let lat = Double(spot.lat)!
            let lng = Double(spot.lng)!
            
            let marker = GMSMarker()
            marker.iconView = markerView
            
            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), index: i, marker : marker, active: !spot.is_closed)
            self.clusterManager.add(item)
            
        }
    }
    
    func markerClick(spot: ElementCoffeeSpot, marker: GMSMarker){
        
        comments.removeAll()
        users.removeAll()
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17)
        self.mapView.animate(to: camera)
        self.mapView.delegate = self
        
        current_coffee_spot = spot
        current_coffee_net = allCoffeeNets[getNetIndexBySpot(spot: spot)]
        
        parrent.isHidden = false
        bottomController?.expandPanel()
        self.getComments()
        
        if self.slideUpView.isHidden {
//            self.slideUpView.show(expandFull: false)
//            slideUpView.isHidden = false
            
            
            
            coffeeLogo.kf.setImage(with: URL(string: current_coffee_net.logo_img)!)
            coffeeImg.kf.setImage(with: URL(string: current_coffee_spot.img)!)
            coffeeName.text = current_coffee_net.name_other!
            coffeeStars.rating = current_coffee_spot.stars!
            coffeeAddress.text = spot.address!
            
            if locationManager.location?.accessibilityActivate() != nil {
                coffeeDistance.isHidden = false
                coffeeDistance.text = getDistance(latF: (locationManager.location?.coordinate.latitude)!, lngF: (locationManager.location?.coordinate.longitude)!,
                                                  latS: Double(spot.lat)!, lngS: Double(spot.lng)!)
            } else {
                coffeeDistance.isHidden = true
            }
            
            
            coffeeWorkTime.text = "Время работи -  \(spot.time_start!) : \(spot.time_finish!)"
            
            
        }
    }
    
    func getComments(){
        getCommentsForNet(company: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.getFilledComments(comments: setElementCommentList(list: value as! [[String : Any]]))
                
                if self.comments.count == 0{
                    
                    print("EMP IN DOWNLOAD")
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = true
                    self.emptyView.isHidden = false
                    
                    
                } else {
                    print("N EMP IN DOWNLOAD")
                    
                    self.collectionView.isHidden = false
                    
                    self.emptyView.isHidden = true
                    
                    
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
            fadeView(view: self.loadingCommentsView, delay: 0.2, isHiden: true)
        }
    }
    
    
    
    
    
    func isOrderInProcess(){
        getActiveUserOrders(userId: "\(current_coffee_user.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orders = value as! [[String : Any]]
                if orders.count == 0{
                    self.loadingView.isHidden = false
                    self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)
                    self.downloadManuLists()
                    print("USER CAN ORDER")
                } else{
                    self.view.makeToast("У вас есть незавершенный заказ")
                    self.stopAnimating()
                    print("USER HAS ORDERS")
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
    
    func getFilledComments(comments: [ElementComment]){
        for x in comments{
            if x.comment != ""{
                self.comments.append(x)
            }
        }
        if self.comments.count > 0{
            getCommentUsers()
        }
    }
    
    func getCommentUsers(){
        getAllUsers().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.users = setElementUserList(list: value as! [[String : Any]])
                self.collectionView?.reloadData()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getAllCoffeeNets(spot: ElementCoffeeSpot, marker: GMSMarker){
        getCoffeeNets().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                allCoffeeNets = setElementCoffeeNetList(list: value as! [[String : Any]])
                self.markerClick(spot: spot, marker: marker)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
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
    
    func downloadManuLists(){
//        loadingView.isHidden = false
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)

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
        goNext()
        
    }
    
    func goNext(){
        
        if tabs.count != 0{
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = Storyboard.instantiateViewController(withIdentifier: "manuPage") as! OrdersVC
            
            controller.tabs = self.tabs
            
            //        let database = Database()
            //        database.deleteProduct()
            //        database.setProducts(products: menu)
            allSpotProducts = menu
            loadingView.isHidden = true
            stopAnimating()
            self.navigationController?.pushViewController(controller, animated: true)
        } else{
            stopAnimating()
            self.view.makeToast("У данной кофейни нету продуктов для заказа")
        }
    }
    @IBAction func toOrderNext(_ sender: Any) {
        self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        if header != nil{
            isOrderInProcess()
        } else {
            self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            self.downloadManuLists()
        }
        
    }
    
    @IBAction func moveToPageCoffee(_ sender: Any) {
        PageCoffee.LoadViewActive = false

        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = Storyboard.instantiateViewController(withIdentifier: "CommentPage") as! PageCoffee
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
