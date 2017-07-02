//
//  Constants.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 02.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import Foundation


struct Constants {
    
    
    static var sensorData = [SensorModel]()
    
    static var devices: [DeviceModel] = [
        
        DeviceModel(id: "1234", name: "KR QUANTEC ultra", sensors: [
            
            SensorModel(id: "sensor temp", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "sensor laut", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "sensor co2", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10"),
            SensorModel(id: "sensor luft", device: "ABB IRB 5400",  type: .Luftfeuchtigkeit, entity: .Luftfeuchtigkeit, value: 300, minValue: 0, maxValue: 550, time: "Heute: 13:10"),
            SensorModel(id: "sensor druck", device: "ABB IRB 5400",  type: .Luftdruck, entity: .Luftdruck, value: 1060, minValue: 0, maxValue: 200, time: "Heute: 13:10")], image: "roboter1", minorValue: 14042),
        
        DeviceModel(id: "123", name: "ABB IRB 5400", sensors: [
            
            SensorModel(id: "sensor temp", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "sensor laut", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "sensor co2", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10")], image: "roboter2", minorValue: 6333),
        
        DeviceModel(id: "12345", name: "ABB IRB 5950", sensors: [
            
            SensorModel(id: "sensor temp", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "sensor laut", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "sensor co2", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10")], image: "roboter3", minorValue: 6179),
        
        DeviceModel(id: "1234", name: "ABB IRB 5200", sensors: [
            
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10")], image: "", minorValue: 5555),
        
        DeviceModel(id: "1234", name: "ABB IRB 5410", sensors: [
            
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10")], image: "", minorValue: 5555),
        
        DeviceModel(id: "1234", name: "ABB IRB 5455", sensors: [
            
            SensorModel(id: "ss", device: "ABB IRB 5400", type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10")], image: "", minorValue: 5555)
        
    ]
    
}
