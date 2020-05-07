//
//  Enums.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 06/05/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

//Варианты слова запроса
enum RequestWord:String {
    case cafe = "cafe"
    case meal_delivery = "meal_delivery"
    case restaurant = "restaurant"
    case bar = "bar"
    
    static func getWord(hour: Int) -> String {
        var word: String = ""
        switch hour {
        case 7 ... 11:
            word = self.cafe.rawValue
        case 12 ... 15:
            word = self.meal_delivery.rawValue
        case 18 ... 21:
            word = self.restaurant.rawValue
        case 22 ... 23:
            word = self.bar.rawValue
        case 0 ... 5:
            word = self.bar.rawValue
        default:
            return word
        }
        return word
    }
}
