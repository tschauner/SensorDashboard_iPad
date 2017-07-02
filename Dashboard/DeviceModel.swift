//
//  DeviceModel.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 02.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

struct DeviceModel {
    
    var id: String
    var name: String
    var sensors: [SensorModel]
    var image: String
    let minorValue: CLBeaconMinorValue
    
//    init(id: String, name: String, sensors: [SensorModel], image: String, minorValue: CLBeaconMinorValue) {
//        self.id = id
//        self.name = name
//        self.sensors = sensors
//        self.image = image
//        self.minorValue = minorValue
//    }
    
    

}
