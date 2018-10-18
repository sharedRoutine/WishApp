//
//  UIColorExtension.swift
//  WishApp
//
//  Created by Janosch Hübner on 08.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(withHex hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue: hex & 0xff)
    }
    
    static let nephritis: UIColor = UIColor(withHex: 0x27ae60)
    static let alizarin: UIColor = UIColor(withHex: 0xe74c3c)
    static let darkJungleGreen: UIColor = UIColor(withHex: 0x1C1C1C)
    static let dark: UIColor = UIColor(withHex: 0x232323)
    static let valhalla: UIColor = UIColor(withHex: 0x2C283D)
    static let darkSlateBlue: UIColor = UIColor(withHex: 0x4C3C81)
}
