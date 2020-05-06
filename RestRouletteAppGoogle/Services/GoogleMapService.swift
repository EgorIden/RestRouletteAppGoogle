//
//  GoogleMapService.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 23/04/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class GoogleMapService {
    
    private let apiKey = "AIzaSyABeqgF2OIlBixbR7fllMvr5llfsKKAfLU"
    
    // MARK: запрос места 
    func requestNearPlaces(latitude: Double, longitude: Double, placeType: String, complition: @escaping([Results]) -> Void) {
        
        print("placetype \(placeType)")
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=600&rankby=prominence&sensor=true&key=\(apiKey)&types=\(placeType)&limit=10"
        
        let baseUrl = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: baseUrl) { (data, response, error) in
            
            DispatchQueue.main.async {
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                        print(response)
                    return
                }
                print(httpResponse.statusCode)
                guard let data = data else{
                    print("Trouble with data")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let places = try decoder.decode(Place.self, from: data)
                    let fetchedResults = places.results
                    print("results in google \(fetchedResults.count)")
                    complition(fetchedResults)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        task.resume()
    }
    
    func makeMarker(map: GMSMapView, userData: PlaceMarker, position: CLLocationCoordinate2D){
        let marker = GMSMarker(position: position)
        marker.userData = userData
        marker.icon = GMSMarker.markerImage(with: UIColor(red: 185/255.0, green: 225/255.0, blue: 223/255.0, alpha: 1))
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = map
    }
}
