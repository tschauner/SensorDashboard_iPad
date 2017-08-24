//
//  SensorModel.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

struct SensorModel {
    
    var id: String
    var device: String
    var type: String
    var entity: String
    var value: Float?
    var time: String?
    var exValue: [ExtremeValueModel?]
     
}
