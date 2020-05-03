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
    let image: UIImage
    
    init(name: String, imageName: String) {
        self.name = name
        self.image = UIImage(named: imageName)!
    }
}
