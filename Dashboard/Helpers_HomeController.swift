//
//  Helpers_HomeController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 07.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

extension HomeController {
    
    
    
    // show viewcontroller with sensordata
    func show(sensorData: SensorModel) {
        
        let chart = ChartViewController()
        
        for device in devices {
            for sensor in device.sensors {
                if sensor.device == sensorData.device {
                    chart.device = device
                    chart.sensor = sensorData
                }
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.buttonView.alpha = 0
        }
        
        navigationController?.pushViewController(chart, animated: true)
    }
    
    // check if sensor is already in use
    func checkIfSensorIsInUse() -> Bool {
        
        for device in devices {
            if beaconsFound.contains(device.minorValue) {
                print("beacon already in use")
                return false
            }
        }
        print("beacon not in use")
        return true
    }
    
    
    
    // updates sensor value in cell
    func updateSensor(with id: String, sensor: SensorModel) {
        
        
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
        for row in 0..<Constants.sensorData.count {
            if Constants.sensorData[row].id == id {
                indexPaths += [IndexPath(row: row, section: 0)]
            }
        }
        
        // Update beacon locations of visible rows.
        if let visibleRows = collectionView?.indexPathsForVisibleItems {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for item in rowsToUpdate {
                let cell = collectionView?.cellForItem(at: item) as! SensorTileCell
                cell.sensor?.value = sensor.value
                cell.refreshColor(from: cell.sensor!)
                showAlarmFor(sensor: cell.sensor!, isActive: alarmIsActivated)
            }
        }
        
    }
    
    
    
    // should get all ids of the sensors in sensordata
    func getSensorIds() -> String {
        
        let idStrings = Constants.sensorData.map { $0.id! }
        let ids = idStrings.joined(separator: "#, ")
        
        return ids
    }
    
    
    
    // shows alarm wheter or not data is too high or low
    func showAlarmFor(sensor: SensorModel, isActive: Bool) {
        
        let min = sensor.minValue ?? 0
        let max = sensor.maxValue ?? 0
        let value = sensor.value ?? 0
        
        let time = currentTimeString()
        
        switch (value, min, max) {
        case let (value, _, max) where value > max:
            
            // if value is too high
            EventsCV.events.insert(EventModel(type: sensor.type.rawValue, time: time, text: .Max), at: 0)
            self.showAlert(with: EventModel(type: sensor.type.rawValue, time: time, text: .Max), activated: alarmIsActivated)
            
        case let (value, min, _) where value < min:
            
            // if value is too low
            EventsCV.events.insert(EventModel(type: sensor.type.rawValue, time: time, text: .Min), at: 0)
            self.showAlert(with: EventModel(type: sensor.type.rawValue, time: time, text: .Min), activated: alarmIsActivated)
            
        default:
            print("nothing happened")
        }
    }
    
    // asks user to add sensor to dashboard
    func promptUser() {
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (action) in
            self.beaconIsConnected = false
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.addSensorManually()
        }
        showAlert(title: "Gerät erkannt", contentText: "Es wurde ein Gerät in ihrer Nähe erkannt. Wollen Sie es hinzufügen?", actions: [okAction, cancelAction])
    }
    
    
    // dashboard connects to server
    func conntectToServer() {
        DispatchQueue.main.async {
            
            if(Socket.sharedInstance.connected) {
                print("already connected")
                self.timer?.invalidate()
            } else {
                print("connecting to server...")
                let res = Socket.sharedInstance.connect(address: self.host, port: Int32(self.port));
                
                if(res.error == nil) {
                    self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.self.checkDataFromServer), userInfo: nil, repeats: true)
                    self.timer?.fire()
                } else {
                    print("\(String(describing: res.error?.localizedDescription))")
                }
            }
        }
    }
    
    
    // should ask sensor for data with ids of all stored sensors
    @objc func checkDataFromServer() {
        
        DispatchQueue.main.async {
            
            let result = Socket.sharedInstance.send(command: self.getSensorIds())
            let index = result.data.index((result.data.startIndex), offsetBy: 2)
            let response = result.data.substring(from: index)
            
            print(response)
            
        }
        
    }
    
}