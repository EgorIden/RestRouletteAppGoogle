//
//  MarkerModel.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 24/04/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

struct Markers: Codable {
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
