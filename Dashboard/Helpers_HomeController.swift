//
//  Helpers_HomeController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 07.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

extension HomeController {
    
    // Funktion zeigt den SensorDetailVC wenn ein Beacon mit dem
    // entsprechenden Minorvalue gefunden wurde
    func showSensorDetailViewController(with device: DeviceModel) {
        
        let sensorDetail = SensorDetailViewController()
        sensorDetail.device = device
        
        let nav = UINavigationController(rootViewController: sensorDetail)
        
        present(nav, animated: true, completion: nil)
        
    }
    
    // Funktion zeigt ChartviewController und übergibt die jeweiligen Sensor/Devicedaten
    // - Button wird ausgeblendet
    // - Timer wird gestoppt
    func show(sensorData: SensorModel) {
        
        let chart = ChartViewController()
        chart.deviceName = sensorData.device
        
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
        HomeController.timer.invalidate()
        navigationController?.pushViewController(chart, animated: true)
    }
    
    // Funktion prüft ob ein Beacon Device schon in Verwendung ist
    // und gibt dann entweder ein false oder true zurück
    func checkIfSensorIsInUse() -> Bool {
        
        if beaconsFound.contains((closestBeacon)!) {
            return false
        }
        print("already in use")
        return true
    }
    
    
    
    // Funktion aktualisiert den Wert in der Cell
    // - vergleicht die Id der des im Array befindenen Sensors
    // - Sucht den enstprechenden IndexPath im CollectionView
    // - Aktualisiert den Wert und passt die Farbe an, falls EV an
    // - Zeigt Alarm, falls EV über/unterschritten ist
    func update(sensor: SensorModel) {
        let id = sensor.id
        var indexPaths = [IndexPath]()
        for row in 0..<Constants.sensorData.count {
            if Constants.sensorData[row].id == id {
                indexPaths += [IndexPath(row: row, section: 0)]
            }
        }

        if let visibleRows = collectionView?.indexPathsForVisibleItems {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for item in rowsToUpdate {
                let cell = collectionView?.cellForItem(at: item) as! SensorTileCell
                cell.sensor?.value = sensor.value
                cell.refreshColor(from: cell.sensor!)
                showAlarmFor(sensor: cell.sensor!)
            }
        }
    }
    
    
    
    // Funktion liest alle SensorId im Array als String und gibt diese zurück
    // - Sensorid entpacken
    // - # an String anhängen
    func sensorIds() -> String {
        
        let idStrings = Constants.sensorData.map { $0.id }
        var ids = idStrings.joined(separator: ",")
        
        ids.append("#")

        return ids
    }
    
    // Funktion gibt den errechneten Extremevaluecodes zurück
    func getEmergencyCode(from sensor: SensorModel) -> Int {
        
        var valCode = 0
        guard let value = sensor.value else { return 0 }
        let exValue = sensor.exValue
        
        for ex in exValue {
            
            guard let exValue = ex?.value else { return 0 }
            guard let newCode = ex?.emergencyCode else { return 0 }
            guard let greater = ex?.greater else { return 0 }
            
            switch (value, greater, exValue) {
            case let (value, greater ,exValue) where greater && value >= exValue && newCode > valCode:
                valCode = newCode
            case let (value, greater ,exValue) where !greater && value <= exValue && newCode > valCode:
                valCode = newCode
            default:
                print("something went wrong")
            }
        }

        return valCode
        
    }
    
    
    // Funktion die einen Alarmt zeigt wenn entsprechende Extremwerte über/unterschritten wurden
    // - Funktion wird nur ausgelöst, wenn der Alarm aktiviert wurde
    func showAlarmFor(sensor: SensorModel) {
        
        let type = sensor.type
    
        let valCode = getEmergencyCode(from: sensor)
        let time = currentTimeString()
        
        let event = EventModel(type: type, time: time, text: Constants.errorCode[valCode])
    
        if alarmIsActivated {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "ACHTUNG", contentText: "Beim \(event.type.uppercased())SENSOR wurde der \(event.text)", actions: [okAction])
            
        }
    }
    
    
    // Funktion die den User fragt ob er das Gerät in der Nähe hinzufügen möchte
    func promptUser() {
        guard let beacon = self.closestBeacon else { return }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (action) in
            self.beaconIsConnected = false
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            self.showSensorDetailViewController(with: Constants.beaconDevices[beacon.hashValue]!)
        }
        
        let deviceName = String(describing: Constants.beaconDevices[beacon.hashValue]!.name)
        showAlert(title: "Gerät erkannt", contentText: "Es wurde das Gerät \(deviceName.uppercased()) in ihrer Nähe erkannt. Wollen Sie es hinzufügen?", actions: [okAction, cancelAction])
    }
    
    
    // Asynchrone Funktion zum Verbinden des Sickets mit dem Server
    // - Beim ersten Verwenden der App werden default Werte geladen,
    // - ansonsten werden gepeicherte Werte genommen
    func conntectToServer() {
        
        let isFirstLaunch = UserDefaults.isFirstLaunch()
        
        if isFirstLaunch {
            port = 8082
            host = "192.168.178.39"
            
        } else {
            if let ip = UserDefaults.standard.value(forKey: "host"),
                let po = UserDefaults.standard.value(forKey: "port") {
                
                host = ip as? String
                port = po as? Int
            }
        }
        
        guard let serverHost = host else { return }
        guard let serverPort = port else { return }
        
        DispatchQueue.main.async {
            if(Socket.sharedInstance.connected) {
                HomeController.timer.invalidate()
            } else {
                
                let res = Socket.sharedInstance.connect(with: serverHost, port: serverPort)
                
                if(res.error == nil) {

                    // connect button ändern
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.showAlert(title: "Yaaaay", contentText: "Verbindung erfolgreich zu \(serverHost) hergestellt", actions: [okAction])
                    
                    if !self.devices.isEmpty {
                        self.sendDataWithTimer()
                    }
                    
                } else {
                    Socket.sharedInstance.disconnect()
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.showAlert(title: "Ooohh", contentText: "Verbindung konnte nicht hergestellt werden", actions: [okAction])
                }
            }
        }
    }
    
    // Funktion die einen Funktion alle 5 sek aufruft
    func sendDataWithTimer() {
        if Socket.sharedInstance.connected {
            HomeController.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.sendData), userInfo: nil, repeats: true)
            HomeController.timer.fire()
        } else {
            
        }
    }
    
    // Asynchrone Funktion sendet alle Sensor Ids und übergibt das Ergebnis an readJsonToString
    @objc func sendData() {
        DispatchQueue.main.async {
            let result = Socket.sharedInstance.send(command: self.sensorIds())
            if result.isEmpty {
                print("json is empty")
            } else {
                self.readJsonToString(with: result)
            }
            
        }
        
    }
    
    // Funktion liest den übergebenen JSON String und aktualisiert den Sensor in der Cell
    // - String lesen
    // - Sensor updaten
    func readJsonToString(with jsonStr: String) {
        guard let data = jsonStr.data(using: String.Encoding.ascii, allowLossyConversion: false) else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            guard let dict = json as? [[String: Any]] else { return }
            for data in dict {
                if let sensorId = data["sensorID"] as? String,
                    let value = data["value"] as? String,
                    let timestamp = data["timestamp"] as? String {

                    let sensor = SensorModel(id: sensorId, device: "", type: "", entity: "", value: Float(value), time: timestamp, exValue: [nil])
                    update(sensor: sensor)
                }
            }
        }
        catch {
            print("Error deserializing JSON: \(error)")
        }
        
    }
    
}
