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
    var device: String?
    var type: SensorType
    var entity: SensorEntity
    var value: Double?
    var minValue: Double?
    var maxValue: Double?
    var time: String
    
    
    // sensor types
    
    enum SensorType: String {
        case Temperatur = "Temperatur"
        case Luftfeuchtigkeit = "Luftfeuchtigkeit"
        case Lautstärke = "Lautstärke"
        case Helligkeit = "Helligkeit"
        case Luftdruck = "Luftdruck"
        case Kohlenmonoxid = "Kohlenmonoxid"
    }
    
    enum SensorEntity: String {
        case Temperatur = " °C"
        case Luftfeuchtigkeit = " %"
        case Lautstärke = " dB"
        case Helligkeit = " lm"
        case Luftdruck = " hPa"
        case Kohlenmonoxid = " ppm"
    }
    
    init(id: String, device: String, type: SensorType, entity: SensorEntity, value: Double, minValue: Double, maxValue: Double, time: String) {
        self.id = id
        self.device = device
        self.type = type
        self.entity = entity
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.time = time
    }
    
    
}
