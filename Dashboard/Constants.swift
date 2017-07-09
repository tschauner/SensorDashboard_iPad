//
//  Constants.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 02.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


struct Constants {
    
    static let adminAlarmText = "Leider fehlen in ihnen hierfür die Berechtigungen. Sprechen Sie mit ihrem Administrator."
    static let libraryOptionText = "Sie haben die Möglichkeit den Sensor über einen QR Code oder per iBeacon hinzufügen."
    static let scannerLesefehler = "Dieses Gerät ist in der Datenbank nicht vorhanden."
    
    static var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    static var maxColor = UIColor.orange
    static let newGreen = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 0.2)
    static var sensorData = [SensorModel]()
    
    static var devicesInUse = [DeviceModel]()
    static var devices: [DeviceModel] = [
        
        DeviceModel(id: "123", name: "KR QUANTEC ultra", sensors: [
            
            SensorModel(id: "sensor temp", device: "KR QUANTEC ultra",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "sensor laut", device: "KR QUANTEC ultra",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "sensor co2", device: "KR QUANTEC ultra",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: ""),
            SensorModel(id: "sensor luft", device: "KR QUANTEC ultra",  type: .Luftfeuchtigkeit, entity: .Luftfeuchtigkeit, value: 300, minValue: 0, maxValue: 550, time: ""),
            SensorModel(id: "sensor druck", device: "KR QUANTEC ultra",  type: .Luftdruck, entity: .Luftdruck, value: 1060, minValue: 0, maxValue: 200, time: "")], image: "roboter", minorValue: 14042),
        
        DeviceModel(id: "1234", name: "Gemüseplantage", sensors: [
            
            SensorModel(id: "sensor temp", device: "Gemüseplantage",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "sensor laut", device: "Gemüseplantage",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "sensor co2", device: "Gemüseplantage",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "")], image: "plantage", minorValue: 6333),
        
        DeviceModel(id: "12345", name: "Serverraum", sensors: [
            
            SensorModel(id: "sensor temp", device: "Serverraum",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "sensor laut", device: "Serverraum",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "sensor co2", device: "Serverraum",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "")], image: "server", minorValue: 6179),
        
        DeviceModel(id: "123456", name: "Serverraum", sensors: [
            
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Luftfeuchtigkeit, entity: .Luftfeuchtigkeit, value: 20, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "")], image: "", minorValue: 5555),
        
        DeviceModel(id: "1234567", name: "ABB IRB 5410", sensors: [
            
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "")], image: "", minorValue: 5555),
        
        DeviceModel(id: "12345678", name: "ABB IRB 5455", sensors: [
            
            SensorModel(id: "ss", device: "ABB IRB 5400", type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "ss", device: "ABB IRB 5400",  type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "")], image: "", minorValue: 5555)
        
    ]
    
}
