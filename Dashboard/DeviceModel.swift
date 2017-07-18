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
    var description: String
    var sensors: [SensorModel]
    var image: String
    let minorValue: CLBeaconMinorValue
    
}
