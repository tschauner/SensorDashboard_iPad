//
//  Constants.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 02.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation


struct Constants {
    
    static let adminAlarmText = "Leider fehlen in ihnen hierfür die Berechtigungen. Sprechen Sie mit ihrem Administrator."
    static let libraryOptionText = "Sie haben die Möglichkeit den Sensor über einen QR Code oder per iBeacon hinzufügen."
    static let scannerLesefehler = "Dieses Gerät ist in der Datenbank nicht vorhanden."
    
    static let errorCode = ["", "Messbrereich unterschritten", "Grenzwert unterschritten", "äußere Grenzwert unterschritten", "Messbrereich überschritten", "Grenzwert überschritten", "äußere Grenzwert überschritten"]
    
    
    static var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    static var maxColor = UIColor.orange
    static let newGreen = UIColor(red: 57/250, green: 145/255, blue: 186/255, alpha: 1)
    
    static var sensorData = [SensorModel]()
    static var devicesInUse = [DeviceModel]()
    
    
    // ALLE DEVICES DIE VON BEACONS ERKANNT WERDEN KÖNNEN
    
    static var beaconDevices: [Int: DeviceModel] = [
        
        
        6179: DeviceModel(id: "device2", name: "Serverraum 22B", description: "Hier befindet sich die Netzwerk-Hardware für Gebäude B. Unter anderem stehen hier Router der Serie 880 und ein Netzwerk-Switch aus der Catalyst 9300 Serie. Das Netz ist auf Kupfer Cat.6a gebaut das 10GBASE-T und damit Datenübertragungsraten von bis zu 10 Gbps erlaubt.", image: "server", minorValue: 6179, sensors: [
            
            SensorModel(id: "snid1", device: "Serverraum 22B", type: "Temperatur", entity: " °C", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 29, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 27, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 25, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 22, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 18, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            )
            
            ]
        ),
        
        
        6333: DeviceModel(id: "device3", name: "Gewächshaus 3 (Stevia)", description: "Auf knapp 3000 m² verteilt finden hier der Anbau von unseren Stevia Pflanzen statt. Hier wird humoses, durchlässiges Substrat verwendet da Staunässe unbedingt zu vermeiden ist.", image: "plantage", minorValue: 6333, sensors: [
            
            SensorModel(id: "snid4", device: "Gewächshaus 3 (Stevia)", type: "Temperatur", entity: " °C", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 34, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 32, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 30, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 25, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 23, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 21, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            ),
            
            
            SensorModel(id: "snid5", device: "Gewächshaus 3 (Stevia)", type: "Luftdruck", entity: " bar", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 1120, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 1100, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 1080, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 970, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 950, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 930, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            ),
            
            
            SensorModel(id: "snid6", device: "Gewächshaus 3 (Stevia)", type: "Höhe", entity: " m", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 45, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 40, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 35, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 25, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 15, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            )
            
            ]
        ),
        
        
        14042: DeviceModel(id: "device1", name: "KR QUANTEC ultra", description: "Der leistungsstarke und präzise Roboter bietet maximale Leistung in jeder Position. Mit einer Nutzlast von 300 kg und einer maximalen Reichweite von 3.100 mm verfügt er über eine hohe Leistungsdichte. Diese Gießvariante ist besonders resistent gegen Verschmutzung, hohe Luftfeuchtigkeit und hohe Temperaturen.", image: "roboter", minorValue: 14042, sensors: [
            
            SensorModel(id: "snid3", device: "KR QUANTEC ultra", type: "Lichtstärke", entity: " lm", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 110, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 90, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 70, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 40, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 10, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            ),
            
            
            SensorModel(id: "snid2", device: "KR QUANTEC ultra", type: "Distanz", entity: " cm", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 70, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 60, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 50, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 10, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 5, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            )
            
            ]
        )
        
        
        
    ]
    
    // ALLE DEVIES IN DER DATENBANK
    
    static var devices: [DeviceModel] = [
        
        DeviceModel(id: "device2", name: "Serverraum 22B", description: "Hier befindet sich die Netzwerk-Hardware für Gebäude B. Unter anderem stehen hier Router der Serie 880 und ein Netzwerk-Switch aus der Catalyst 9300 Serie. Das Netz ist auf Kupfer Cat.6a gebaut das 10GBASE-T und damit Datenübertragungsraten von bis zu 10 Gbps erlaubt.", image: "server", minorValue: 6179, sensors: [
            
            SensorModel(id: "snid1", device: "Serverraum 22B", type: "Temperatur", entity: " °C", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 29, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 27, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 25, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 22, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 18, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            )
            
            ]
        ),
        
        
        DeviceModel(id: "device3", name: "Gewächshaus 3 (Stevia)", description: "Auf knapp 3000 m² verteilt finden hier der Anbau von unseren Stevia Pflanzen statt. Hier wird humoses, durchlässiges Substrat verwendet da Staunässe unbedingt zu vermeiden ist.", image: "plantage", minorValue: 6333, sensors: [
            
            SensorModel(id: "snid4", device: "Gewächshaus 3 (Stevia)", type: "Temperatur", entity: " °C", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 34, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 32, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 30, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 25, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 23, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 21, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            ),
            
            
            SensorModel(id: "snid5", device: "Gewächshaus 3 (Stevia)", type: "Luftdruck", entity: " bar", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 1120, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 1100, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 1080, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 970, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 950, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 930, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            ),
            
            
            SensorModel(id: "snid6", device: "Gewächshaus 3 (Stevia)", type: "Höhe", entity: " m", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 45, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 40, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 35, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 25, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 15, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            )
            
            ]
        ),
        

        DeviceModel(id: "device1", name: "KR QUANTEC ultra", description: "Der leistungsstarke und präzise Roboter bietet maximale Leistung in jeder Position. Mit einer Nutzlast von 300 kg und einer maximalen Reichweite von 3.100 mm verfügt er über eine hohe Leistungsdichte. Diese Gießvariante ist besonders resistent gegen Verschmutzung, hohe Luftfeuchtigkeit und hohe Temperaturen.", image: "roboter", minorValue: 14042, sensors: [
            
            SensorModel(id: "snid3", device: "KR QUANTEC ultra", type: "Lichtstärke", entity: " lm", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 110, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 90, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 70, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 40, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 10, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            ),
            
            
            SensorModel(id: "snid2", device: "KR QUANTEC ultra", type: "Distanz", entity: " cm", value: nil, time: nil, exValue:
                
                
                [
                    ExtremeValueModel(value: 70, greater: true, emergencyCode: 6, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 60, greater: true, emergencyCode: 5, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 50, greater: true, emergencyCode: 4, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 20, greater: false, emergencyCode: 1, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 10, greater: false, emergencyCode: 2, codeName: "Kritisch"),
                    
                    ExtremeValueModel(value: 5, greater: false, emergencyCode: 3, codeName: "Kritisch")
                ]
            )
            
            ]
        )
        
    ]
    
}
