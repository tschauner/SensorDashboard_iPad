//
//  ColorSet.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 11.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ColorSet {
    
    var backgroundColor: UIColor
    var fontColor: UIColor
    var secondFontColor: UIColor
    
    init(backgroundColor: UIColor, fontColor: UIColor, secondFontColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.fontColor = fontColor
        self.secondFontColor = secondFontColor
    }
}
