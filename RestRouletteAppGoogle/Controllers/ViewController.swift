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
    
    private var googleMapService = GoogleMapService()
    private var locationManager = CLLocationManager()
//    private var myLatitude: CLLocationDegrees?
//    private var myLongitude: CLLocationDegrees?
    private var places: [Results]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
//        self.myLatitude = locationManager.location?.coordinate.latitude
//        self.myLongitude = locationManager.location?.coordinate.longitude
        
        print("viewdidload")
        
    }
   //поисковый запрос /*https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=59.93667,30.315&radius=200&rankby=prominence&sensor=true&key=AIzaSyDH_kKUEidg_Ao77O4s12j1UuYDjAh_Ezc&types=cafe*/
    
    private func displayNearPlacesOnMap(lat: CLLocationDegrees, long: CLLocationDegrees){
        //создание камеры и карты
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        //добавление кнопки локации
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        //создание маркеров и добавление их на карту
        getNearPlaceFromTime(lat: lat, long: long) { fetchedResults in
            if fetchedResults.count >= 4{
                for i in 0...4{
                    
                    let position = CLLocationCoordinate2D(latitude: fetchedResults[i].geometry.location.lat, longitude: fetchedResults[i].geometry.location.lng)
                    
                    let marker = GMSMarker(position: position)
                    marker.title = fetchedResults[i].name
                    marker.icon = GMSMarker.markerImage(with: .black)
                    //marker.appearAnimation = GMSMarkerAnimation.pop
                    marker.map = mapView
                    print("\(fetchedResults[i].name)")
                }
            }
            self.view.addSubview(mapView)
        }
    }
    
    //получение мест в зависимости от времени
    private func getNearPlaceFromTime(lat: Double, long: Double, complition: @escaping ([Results]) -> Void) {
        
        //получение текущего времни
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        print(hour)
        
        //в зависимости от времени меняется тип места
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
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else{return}
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        //текущие координаты пользователя
        if let myLatitude = locations.first?.coordinate.latitude, let myLongitude = locations.first?.coordinate.longitude, locationManager.monitoredRegions.isEmpty{
            locationManager.stopUpdatingLocation()
            displayNearPlacesOnMap(lat: myLatitude, long: myLongitude)
            
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
