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
    private var currentLatitude = 0.0
    private var currentLongitude = 0.0
    private var bottomMenu = BottoMenu()
    private var popUpMarkersInformation = PopUpMarkersInformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: настройка карты и локации
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude, zoom: 15)
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
        locationManager.allowsBackgroundLocationUpdates = true
        
    }
    
    // MARK: получение места по тапу
    
    func showCategoryMarker(type: String?){
        if let type = type{
            print(type)
            getNearPlaceFromTime(lat: self.currentLatitude, long: self.currentLongitude, placeType: type) { fetchedResults in
                print("results \(fetchedResults.count)")
                    if fetchedResults.count >= 4{
                    self.mapView.clear()
                    for i in 0...4{
                        let markerData = PlaceMarker(name: fetchedResults[i].name,
                                                     vicinity: fetchedResults[i].vicinity,
                                                     location: fetchedResults[i].geometry.location)
                        let position = CLLocationCoordinate2D(latitude: markerData.location.lat, longitude: markerData.location.lng)
                        self.googleMapService.makeMarker(map: self.mapView, userData: markerData, position: position)
                        print("\(fetchedResults[i].name)")
                        }
                    }else{
                        self.showInformationAlert(title: "Места не найдены", text: "Поблизости нет подходящих мест")
                    }
                }
            }
    }
    
    // MARK: алерт
    private func showInformationAlert(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: получение мест в зависимости от времени
    private func getNearPlaceFromTime(lat: Double, long: Double, placeType: String?, complition: @escaping ([Results]) -> Void) {
        
        //получение текущего времни
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        print("время \(hour)")
        
        if let type = placeType{
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: type) { fetchedResults in
                complition(fetchedResults)
            }
        }else{
            let type = RequestWord.getWord(hour: hour)
            if type != ""{
                googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: type) { fetchedResults in
                    complition(fetchedResults)
                }
            }else{
                showInformationAlert(title: "Места не найдены", text: "Воспользуйтесь ручным поиском")
            }
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
        
        //добавление нижнего меню
        bottomMenu.showBottomMenu(controller: self)
        
        //текущие координаты пользователя
        let location: CLLocation = locations.last!
        self.currentLatitude = location.coordinate.latitude
        self.currentLongitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        
        //перемещение на координаты пользователя и добавление маркеров на карту
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        
        getNearPlaceFromTime(lat: location.coordinate.latitude, long: location.coordinate.longitude, placeType: nil) { fetchedResults in
            print("results \(fetchedResults.count)")
                if fetchedResults.count > 4{
                self.mapView.clear()
                for i in 0...4{
                    let markerData = PlaceMarker(name: fetchedResults[i].name,
                                                 vicinity: fetchedResults[i].vicinity,
                                                 location: fetchedResults[i].geometry.location)
                    let position = CLLocationCoordinate2D(latitude: markerData.location.lat, longitude: markerData.location.lng)
                    self.googleMapService.makeMarker(map: self.mapView, userData: markerData, position: position)
                }
            }else{
                    self.showInformationAlert(title: "Места не найдены", text: "Воспользуйтесь ручным поиском")
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
        let tappedMarker = marker.userData as! PlaceMarker
        let camera = GMSCameraPosition.camera(withLatitude: tappedMarker.location.lat, longitude: tappedMarker.location.lng, zoom: 15)
        mapView.animate(to: camera)
        popUpMarkersInformation.showPopUpMarkersInformation(controller: self, tappedMarker: tappedMarker)
        return true
    }
}
