//
//  UIColourExtensionGorHex.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 04/12/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
