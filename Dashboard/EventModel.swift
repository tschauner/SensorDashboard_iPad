//
//  EventModel.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class EventModel {
    
    var time: String
    var text: Events
    
    
    // possible events
    
    enum Events: String {
        case TemperaturMax = "Ein Teperaturgrenzwert wurde überschritten"
        case TemperaturMin = "Ein Teperaturgrenzwert wurde unterschritten"
    }
    
    init(time: String, text: Events) {
        self.time = time
        self.text = text
    }
}
