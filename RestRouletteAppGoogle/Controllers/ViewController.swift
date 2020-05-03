//
//  ViewController.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 19/04/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: базовые свойства
    @IBOutlet weak var mapView: GMSMapView!
    private var googleMapService = GoogleMapService()
    private var locationManager = CLLocationManager()
    private var defaultLocation = CLLocation(latitude: 55.751999, longitude: 37.617734)
    private var currentLatitude: CLLocationDegrees?
    private var currentLongitude: CLLocationDegrees?
    let bottomMenu = BottoMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: настройка карты и локации
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.isHidden = true
        
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    //поисковый запрос /*https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=59.93667,30.315&radius=200&rankby=prominence&sensor=true&key=AIzaSyDH_kKUEidg_Ao77O4s12j1UuYDjAh_Ezc&types=cafe*/
    
    // MARK: передача мест
    func displayNearPlacesOnMap(lat: CLLocationDegrees, long: CLLocationDegrees, complition: @escaping ([Results]) -> Void) {
        
        getNearPlaceFromTime(lat: lat, long: long) { fetchedResults in
            complition(fetchedResults)
        }
    }
    
    // MARK: получение мест в зависимости от времени
    private func getNearPlaceFromTime(lat: Double, long: Double, complition: @escaping ([Results]) -> Void) {
        
        //получение текущего времни
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        print(hour)
        
        //зависимость места от времени
        switch hour {
        case 7 ... 11:
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "cafe") { fetchedResults in
                complition(fetchedResults)
            }
        case 12 ... 15:
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "meal_delivery") { fetchedResults in
                complition(fetchedResults)
            }
        case 17 ... 21:
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "restaurant") { fetchedResults in
                complition(fetchedResults)
            }
        case 22 ... 23:
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "bar") { fetchedResults in
                complition(fetchedResults)
            }
        case 0 ... 5:
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "bar") { fetchedResults in
                complition(fetchedResults)
            }
        default:
            break
        }
    }
}
// MARK: экстеншены
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else{return}
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: получение локации пользователя
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        //нижнее меню
        bottomMenu.showBottomMenu(controller: self)
        
        //текущие координаты пользователя
        let location: CLLocation = locations.last!
        self.currentLatitude = location.coordinate.latitude
        self.currentLongitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        print("location \(location.description)")
        
        //перемещение на координаты пользователя и добавление маркеров на карту
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        
        displayNearPlacesOnMap(lat: location.coordinate.latitude, long: location.coordinate.longitude) { fetchedResults in
                if fetchedResults.count >= 4{
                for i in 0...4{
                    let position = CLLocationCoordinate2D(latitude: fetchedResults[i].geometry.location.lat, longitude: fetchedResults[i].geometry.location.lng)

                    let marker = GMSMarker(position: position)
                    marker.title = fetchedResults[i].name
                    marker.icon = GMSMarker.markerImage(with: .black)
                    marker.appearAnimation = GMSMarkerAnimation.pop
                    marker.map = self.mapView
                    print("\(fetchedResults[i].name)")
                }
            }else{
                    print(fetchedResults.count)
                for i in 0...fetchedResults.count{
                    let position = CLLocationCoordinate2D(latitude: fetchedResults[i].geometry.location.lat, longitude: fetchedResults[i].geometry.location.lng)
                    
                    let marker = GMSMarker(position: position)
                    marker.title = fetchedResults[i].name
                    marker.icon = GMSMarker.markerImage(with: .black)
                    marker.appearAnimation = GMSMarkerAnimation.pop
                    marker.map = self.mapView
                    print("\(fetchedResults[i].name)")
                }
            }
        }
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        print("координаты")
    }
}
extension ViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var title = marker.title
        print(title)
        return true
    }
}
