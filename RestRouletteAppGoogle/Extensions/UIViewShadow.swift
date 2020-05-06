//
//  UIViewShadow.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 06/05/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 10

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
