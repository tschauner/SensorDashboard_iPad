//
//  DeviceModel.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 02.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

class DeviceModel {
    
    var name: String
    var sensors: [SensorModel]
    var image: String
    let minorValue: CLBeaconMinorValue
    
    init(name: String, sensors: [SensorModel], image: String, minorValue: CLBeaconMinorValue) {
        
        self.name = name
        self.sensors = sensors
        self.image = image
        self.minorValue = minorValue
    }
    

}
