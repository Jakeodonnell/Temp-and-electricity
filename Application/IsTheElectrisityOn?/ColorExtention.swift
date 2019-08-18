//
//  ColorExtention.swift
//  tempapp
//
//  Created by Jake O´Donnell on 2018-11-29.
//  Copyright © 2018 Jake O´Donnell. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, c: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: c)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33, c: 1)
    static let backgroundColorTwo = UIColor.rgb(r: 21, g: 22, b: 100, c: 1)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111, c: 1)
    
    static let highTempPulsatingInner = UIColor.rgb(r: 56, g: 25, b: 49, c: 1)
    static let highTempPulsating = UIColor.rgb(r: 86, g: 30, b: 63, c: 1)
    
    static let lowTempPulsating = UIColor.rgb(r: 0, g: 100 , b: 0, c: 1)
    static let lowTempPulsatingInner = UIColor.rgb(r: 0, g: 70 , b: 0, c: 1)
    
    static let transparentColor = UIColor.rgb(r: 30, g: 157 , b: 252, c: 1)
    
    static let innerlayer = UIColor.rgb(r: 200, g: 200 , b: 100, c: 1)
    
    static let outerlayer = UIColor.rgb(r: 27, g: 157 , b: 252, c: 1)

}
