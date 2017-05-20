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
    
    enum Events: String {
        case TemperaturMax = "Ein Teperaturgrenwert wurde überschritten"
        case TemperaturMin = "Ein Teperaturgrenwert wurde unterschritten"
    }
    
    init(time: String, text: Events) {
        self.time = time
        self.text = text
    }
}
