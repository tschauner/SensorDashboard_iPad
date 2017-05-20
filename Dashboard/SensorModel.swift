//
//  SensorModel.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class SensorModel {
    
    var id: String?
    var type: SensorType
    var entity: SensorEntity
    var value: Int?
    var minValue: Int?
    var maxValue: Int?
    var time: String
    
    enum SensorType: String {
        case Temperatur = "Temperatur"
        case Luftfeuchtigkeit = "Luftfeuchtigkeit"
        case Lautstärke = "Lautstärke"
        case Helligkeit = "Helligkeit"
    }
    
    enum SensorEntity: String {
        case Temperatur = "° Celsius"
        case Luftfeuchtigkeit = " %"
        case Lautstärke = " Dezibel"
        case Helligkeit = " Lumen"
    }
    
    init(id: String, type: SensorType, entity: SensorEntity, value: Int, minValue: Int, maxValue: Int, time: String) {
        self.id = id
        self.type = type
        self.entity = entity
        self.value = value
        self.minValue = minValue
        self.minValue = maxValue
        self.time = time
    }

    
}
