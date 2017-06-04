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
    var type: String
    
    
    // possible events
    
    enum Events: String {
        case Max = "wurde überschritten"
        case Min = "wurde unterschritten"
    }
    
    init(type: String, time: String, text: Events) {
        self.time = time
        self.text = text
        self.type = type
    }
}
