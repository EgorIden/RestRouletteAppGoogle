//
//  MenuCategory.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 03/05/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

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
