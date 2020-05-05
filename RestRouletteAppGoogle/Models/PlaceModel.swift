//
//  MarkerModel.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 24/04/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

struct Place: Codable {
    var results: [Results]
}
struct Results: Codable {
    var geometry: Geometry
    var icon: String
    var name: String
    var vicinity: String
}
struct Geometry: Codable {
    var location: Location
}
struct Location: Codable {
    var lat: Double
    var lng: Double
}

struct PlaceMarker {
    var name: String
    var vicinity: String
    var location: Location
    
    init(name: String, vicinity: String, location: Location) {
        self.name = name
        self.vicinity = vicinity
        self.location = location
    }
}
