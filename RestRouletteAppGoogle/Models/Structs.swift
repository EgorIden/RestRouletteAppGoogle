//
//  MarkerModel.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 24/04/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

// модель парсинга
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

//модель маркера
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

//модель нижнего меню
struct MenuCategory {
    let name: String
    let image: String
    let type: String
    
    init(name: String, imageName: String, type: String) {
        self.name = name
        self.image = imageName
        self.type = type
    }
}


