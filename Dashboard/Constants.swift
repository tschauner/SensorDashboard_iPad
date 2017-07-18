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
        
        DeviceModel(id: "device1", name: "KR QUANTEC ultra", sensors: [
            
            SensorModel(id: "snid1", device: "KR QUANTEC ultra",  type: "Temperatur", entity: " °C", value: -2, minValue: 0, maxValue: 60, time: ""),
            SensorModel(id: "snid2", device: "KR QUANTEC ultra",  type: "Lautstärke", entity: " dB", value: 40, minValue: 0, maxValue: 60, time: ""),
            SensorModel(id: "snid3", device: "KR QUANTEC ultra",  type: "Kohlenmonoxid", entity: " ppm", value: 220, minValue: 0, maxValue: 150, time: "")], image: "roboter", minorValue: 14042),
        
        DeviceModel(id: "snid2", name: "Gemüseplantage", sensors: [
            
            SensorModel(id: "snid1", device: "Gemüseplantage",  type: "Temperatur", entity: " °C", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid2", device: "Gemüseplantage",  type: "Lautstärke", entity: " dB", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid3", device: "Gemüseplantage",  type: "Kohlenmonoxid", entity: " ppm", value: 0, minValue: 0, maxValue: 150, time: "")], image: "plantage", minorValue: 6333),
        
        DeviceModel(id: "device2", name: "Serverraum", sensors: [
            
            SensorModel(id: "snid1", device: "Serverraum",  type: "Temperatur", entity: " °C", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid2", device: "Serverraum",  type: "Lautstärke", entity: " dB", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid3", device: "Serverraum",  type: "Kohlenmonoxid", entity: " ppm", value: 0, minValue: 0, maxValue: 150, time: "")], image: "server", minorValue: 6179),
        
        DeviceModel(id: "device3", name: "Serverraum", sensors: [
            
            SensorModel(id: "snid1", device: "ABB IRB 5400",  type: "Temperatur", entity: " °C", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid2", device: "ABB IRB 5400",  type: "Luftfeuchtigkeit", entity: " %", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid3", device: "ABB IRB 5400",  type: "Kohlenmonoxid", entity: " ppm", value: 0, minValue: 0, maxValue: 150, time: "")], image: "", minorValue: 5555),
        
        DeviceModel(id: "device4", name: "ABB IRB 5410", sensors: [
            
            SensorModel(id: "snid1", device: "ABB IRB 5400",  type: "Temperatur", entity: " °C", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid2", device: "ABB IRB 5400",  type: "Lautstärke", entity: " dB", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid3", device: "ABB IRB 5400",  type: "Kohlenmonoxid", entity: " ppm", value: 0, minValue: 0, maxValue: 150, time: "")], image: "", minorValue: 5555),
        
        DeviceModel(id: "device5", name: "ABB IRB 5455", sensors: [
            
            SensorModel(id: "snid1", device: "ABB IRB 5400", type: "Temperatur", entity: " °C", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid2", device: "ABB IRB 5400",  type: "Lautstärke", entity: " dB", value: 0, minValue: 0, maxValue: 50, time: ""),
            SensorModel(id: "snid3", device: "ABB IRB 5400",  type: "Kohlenmonoxid", entity: " ppm", value: 0, minValue: 0, maxValue: 150, time: "")], image: "", minorValue: 5555)
        
    ]
    
}
