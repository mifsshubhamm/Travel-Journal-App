//
//  MapViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 18/08/23.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //MARK: Variables
    let manager = CLLocationManager()
    lazy var viewModel = { HomeViewModel() }()
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var tappedMarker : GMSMarker?
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        hideNavigationBar()
        GMSServices.provideAPIKey(AppValueConstant.googleMapKey)
    }
    
    //MARK: location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil else {
            return
        }
        startIndicatingActivity()
        viewModel.getPostData() { [self] list in
            viewModel.list = list
            if list.isEmpty {
                self.singleButtonAlertbox("", AppStringConstant.noPostFound, AppStringConstant.ok ) {
                    self.fetchLocation()
                }
            } else {
                let camera = GMSCameraPosition.camera(withLatitude:list[list.count-1 ].locationMain.latitude, longitude: list[list.count-1 ].locationMain.longitude, zoom: 4)
                mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
                mapView.delegate = self
                self.view.addSubview(mapView)
                mapView.clear()
                for (i,element) in list.enumerated() {
                    showCustomMarkers(data: element, index: i)
                }
            }
            self.stopIndicatingActivity()
        }
    }
    
    //MARK: show custom markers
    func showCustomMarkers(data: AddCoverPhotosAndDetailsModel, index: Int) {
        let marker=GMSMarker()
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: data.coverImage, borderColor: UIColor.darkGray, tag: index)
        marker.iconView=customMarker
        marker.position = CLLocationCoordinate2D(latitude:data.locationMain.latitude, longitude: data.locationMain.longitude)
        marker.map = self.mapView
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let tag = customMarkerView.tag
        goToPostDetailsScreen(index: tag)
        return false
    }
    
    //MARK: go to Post details screen
    func goToPostDetailsScreen(index: Int) {
        guard let postDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.postDetailsViewController) as? PostDetailsViewController else { return }
        postDetailsViewController.firebaseUId = viewModel.list[index].firebaseUID
        self.navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
    
    //MARK: Fetch location
    func fetchLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            guard let currentLocation = locationManager.location?.coordinate else { return }
            let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let camera = GMSCameraPosition.camera(withLatitude:location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12)
            mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            mapView.delegate = self
            self.view.addSubview(mapView)
            break
        case .notDetermined, .restricted, .denied:
            self.locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
}
