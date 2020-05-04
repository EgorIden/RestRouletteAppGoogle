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
    
    var placeType: String?{
        didSet{
            if let type = self.placeType{
                print(type)
                getNearPlaceFromTime(lat: self.currentLatitude, long: self.currentLongitude, placeType: type) { fetchedResults in
                    print("results \(fetchedResults.count)")
                        if fetchedResults.count >= 4{
                        self.mapView.clear()
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
                            self.showInformationAlert(title: "Места не найдены", text: "Поблизости нет подходящих мест")
                        }
                    }
                }
            }
    }
    
    //поисковый запрос /*https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=59.93667,30.315&radius=200&rankby=prominence&sensor=true&key=AIzaSyDH_kKUEidg_Ao77O4s12j1UuYDjAh_Ezc&types=cafe*/
    
    // MARK: получение мест в зависимости от времени
    private func getNearPlaceFromTime(lat: Double, long: Double, placeType: String?, complition: @escaping ([Results]) -> Void) {
        
        //получение текущего времни
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        print(hour)
        
        if let type = placeType{
            googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: type) { fetchedResults in
                complition(fetchedResults)
            }
        }else{
            switch hour {
            case 7 ... 11:
                googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "cafe") { fetchedResults in
                    complition(fetchedResults)
                }
            case 12 ... 15:
                googleMapService.requestNearPlaces(latitude: lat, longitude: long, placeType: "meal_delivery") { fetchedResults in
                    complition(fetchedResults)
                }
            case 18 ... 21:
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
                showInformationAlert(title: "Нет результатов", text: "Воспользуйтесь ручным поиском")
            }
        }
    }
    // MARK: алерт
    func showInformationAlert(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
        popUpMarkersInformation.showPopUpMarkersInformation(controller: self)
        return true
    }
}
