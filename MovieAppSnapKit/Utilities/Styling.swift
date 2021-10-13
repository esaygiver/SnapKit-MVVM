//
//  Styling.swift
//  MovieAppSnapKit
//
//  Created by Erol on 29.09.2021.
//

import UIKit

struct Styling {
    
    enum FontWeight: String {
        case bold
        case regular
        case semibold
        case medium
    }
    
    enum ColorCode {
        case white
        case black
        case lighterGray
        case moreLighterGray
        case gray
    }
    
    enum FontName: String {
        case helvetica
        case mulish
        case thonburi
    }
    
    static func colorForCode(_ colorCode: ColorCode) -> UIColor {
        switch colorCode {
        case .white:
            return UIColor.colorFromRGB(r: 1, g: 1, b: 1)
        case .black:
            return UIColor.colorFromRGB(r: 0, g: 0, b: 0)
        case .lighterGray:
            return UIColor.colorFromRGB(r: 255, g: 255, b: 255).withAlphaComponent(0.94)
        case .moreLighterGray:
            return UIColor.colorFromRGB(r: 245, g: 245, b: 245, a: 1)
        case .gray:
            return UIColor.colorFromRGB(r: 220, g: 220, b: 220)
        }
    }
    
    
    static func font(fontName: FontName, weight: FontWeight, size: Float) -> UIFont {
        if let font = UIFont.init(name: "\(fontName.rawValue.capitalized)-\(weight.rawValue.capitalized)", size: CGFloat(size)) {
            return font
        } else {
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
    }
}
