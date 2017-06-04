//
//  DeviceModel.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 02.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class DeviceModel {
    
    var name: String
    var sensors: [SensorModel]
    var image: String
    
    init(name: String, sensors: [SensorModel], image: String) {
        self.name = name
        self.sensors = sensors
        self.image = image
    }
}
