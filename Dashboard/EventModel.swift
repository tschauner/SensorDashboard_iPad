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
    var text: String
    var type: String
    
    
    enum ErrorCode: String {
        case min1 = "Messbrereich unterschritten"
        case min2 = "Grenzwert unterschritten"
        case min3 = "Äußerer Grenzwert unterschritten"
        case max1 = "Messbrereich überschritten"
        case max2 = "Grenzwert überschritten"
        case max3 = "Äußerer Grenzwert überschritten"
        
    }
    
    init(type: String, time: String, text: String) {
        self.time = time
        self.text = text
        self.type = type
    }
}
