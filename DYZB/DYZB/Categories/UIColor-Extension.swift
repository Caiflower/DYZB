//
//  UIColor-Extension.swift
//  DYZB
//
//  Created by 花菜ChrisCai on 2016/10/3.
//  Copyright © 2016年 花菜ChrisCai. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor(r: r, g: g, b: b)
    }
}
