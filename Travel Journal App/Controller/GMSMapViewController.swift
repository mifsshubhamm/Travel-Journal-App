//
//  GMSMapViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 24/08/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GMSMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapPinOutlet: UIImageView!
    @IBOutlet weak var searchLocation: UIButton!
    
    //MARK: Variables
    var locationManager = CLLocationManager()
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    var GoogleMapView:GMSMapView!
    var geoCoder :CLGeocoder!
    var gMSMapModel = GMSMapModel(country: "", locality: "", subLocality: "", thoroughfare: "", subThoroughfare: "", postalCode: "", address: "", latitude: 0.0, longitude: 0.0)
    var gMSProtocol: GMSMapProtocol?
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
    }
    
    //MARK: Action
    @IBAction func searchLocationButton(_ sender: UIButton) {
        GMSPlacesClient.provideAPIKey(AppValueConstant.googleMapKey)
        GMSServices.provideAPIKey(AppValueConstant.googleMapKey)
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        gMSProtocol?.getGMSMapData(data: gMSMapModel)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: initView
    func initView() {
        geoCoder = CLGeocoder()
        locationManager.delegate = self
        fetchLocation()
    }
    
    //MARK: fetch location
    func fetchLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if gMSMapModel.latitude == 0.0 {
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                guard let currentLocation = locationManager.location?.coordinate else { return }
                let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                setUpMap()
            } else {
                latitude = gMSMapModel.latitude
                longitude = gMSMapModel.longitude
                setUpMap()
            }
            break
        case .notDetermined, .restricted, .denied:
            self.locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
    
    //MARK: location manager did change authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            fetchLocation()
            break
        case .notDetermined, .restricted, .denied:
            self.locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
    
    //MARK: setup map
    func setUpMap(){
        let camera = GMSCameraPosition.camera(withLatitude:self.latitude, longitude: self.longitude, zoom: 16)
        GoogleMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
        GoogleMapView.delegate = self
        self.mapView.addSubview(GoogleMapView)
        self.mapView.bringSubviewToFront(mapPinOutlet)
    }
    
    // MARK: - CoreLocation Delegate Methods
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if (error) != nil {
            print(error ?? "")
        }
    }
    
    //MARK: location manager
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        longitude = coord.longitude
        latitude = coord.latitude
        setUpMap()
    }
    
    
    //MARK: GMS Camera Position
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        let lat = position.target.latitude
        let lng = position.target.longitude
        
        // Create Location
        let location = CLLocation(latitude: lat, longitude: lng)
        
        // Geocode Location
        geoCoder.reverseGeocodeLocation(location) { [self] (placemarks, error) in
            if (error != nil){
                print(error!.localizedDescription)
            } else {
                let pm = placemarks as [CLPlacemark]?
                if pm?.count ?? 0 > 0 {
                    let pm = placemarks![0]
                    gMSMapModel.country = pm.country ?? ""
                    gMSMapModel.locality = pm.locality ?? ""
                    gMSMapModel.subLocality = pm.subLocality ?? ""
                    gMSMapModel.thoroughfare = pm.thoroughfare ?? ""
                    gMSMapModel.postalCode = pm.postalCode ?? ""
                    gMSMapModel.subThoroughfare = pm.subThoroughfare ?? ""
                    gMSMapModel.latitude = pm.location?.coordinate.latitude ?? 0.0
                    gMSMapModel.longitude = pm.location?.coordinate.longitude ?? 0.0
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    self.searchLocation.setTitle(addressString, for: .normal)
                    gMSMapModel.address = addressString
                }
            }
        }
    }
}

//MARK: GMS Autocomplete ViewController Delegate
extension GMSMapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
        setUpMap()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        startIndicatingActivity()
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        stopIndicatingActivity()
    }
    
}
