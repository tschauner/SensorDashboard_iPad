//
//  FindSensorController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 11.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

class SensorLibraryController: UICollectionViewController {
    

    let cellId = "cellId"
    var devices = [DeviceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIBarbutton Item "Abbrechen" um den View zu beenden
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        
        setupCollectionView()
        
        setupHeaderView()
        
    }
    
    // Funktion gibt alle Ids der im Array gespeicherten Devices zurück
    // - Alle Id in einem String speichern (idStrings)
    // - Per Komma separieren
    // - Am ende ein # anhängen
    func deviceIds() -> String {
        
        let idStrings = Constants.sensorData.map { $0.id }
        var ids = idStrings.joined(separator: ",")
        
        ids.append("#")
        
        return ids
    }
    
    // Funktion sendet alle vorhandenen Device Ids über die Socketverbindung
    // und speichert den Rückgabe wert in einer Variable
    // - Senden und speichern des Rückgabewerts
    // - Übergeben der Variable an getDataFrom Funktion
    func getDeviceInformation() {
        
        // Asynchrone Verarbeitung
        DispatchQueue.main.async {
            let result = Socket.sharedInstance.send(command: self.deviceIds())

            if !result.isEmpty {
                self.getDataFrom(jsonString: result)
            }
            
        }
    }
    
    
    // Funktion liest JSON Dateien und speichert diese in einem DeviceModel Objekt
    // - ExtremeValueModel
    // - SensorModel(ExtremeValueModel)
    // - DeviceModel(SensorModel)
    func getDataFrom(jsonString: String) {
        
        var sensoren = [SensorModel]()
        var exValues = [ExtremeValueModel]()
        
        guard let data = jsonString.data(using: String.Encoding.ascii, allowLossyConversion: false) else { return }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let data = json as? [[String: Any]] else { return }
            
            for d in data {
                guard let deviceID = d["deviceID"] as? String else { return }
                guard let name = d["name"] as? String else { return }
                guard let description = d["description"] as? String else { return }
                guard let sensors = d["sensor"] as? [[String: Any]] else { return }
                
                for sen in sensors {
                    guard let sensorId = sen["sensorID"] as? String else { return }
                    guard let sensorType = sen["type"] as? String else { return }
                    guard let entity = sen["unit"] as? String else { return }
                    guard let exValue = sen["exValue"] as? [[String: Any]] else { return }
                    
                    for ex in exValue {
                        guard let exVal = ex["value"] as? Float else { return }
                        guard let greater = ex["greater"] as? Bool else { return }
                        guard let emergency = ex["emergencyCode"] as? Int else { return }
                        guard let codeName = ex["codeName"] as? String else { return }
                        
                        let exv = ExtremeValueModel(value: exVal, greater: greater, emergencyCode: emergency, codeName: codeName)
                        exValues.append(exv)
                    }
                    
                    let senor = SensorModel(id: sensorId, device: name, type: sensorType, entity: entity, value: nil, time: "", exValue: exValues)
                    sensoren.append(senor)
                }
                
                // switch weist die Device Bilder je nach ID zu
                var deviceImage = ""
                switch deviceID {
                case "device1":
                    deviceImage = "roboter"
                case "device2":
                    deviceImage = "plantage"
                case "device3":
                    deviceImage = "server"
                default:
                    deviceImage = "empty"
                }
                
                let device = DeviceModel(id: deviceID, name: name, description: description, image: deviceImage, minorValue: 0, sensors: sensoren)
                devices.append(device)
                
                collectionView?.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    
    
    
    // Funktion zum initialisiertn des CollectionViews
    // - Frame, Scrollrichtung, Spacing, BackgroundColor wird festgelegt
    // - Cell wird registriert
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            
            // die Größe der Cells
            flowLayout.itemSize = CGSize(width: 180, height: 150)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // hier wird die SensorLibraryCell im CollectionView registriert
        collectionView?.register(SensorLibraryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // Funktion zeigt den addsensorController VC an
    func showAddSensorController() {
        
        let addSensor = AddSensorController()
        
        navigationController?.pushViewController(addSensor, animated: true)
    }
    
    // Funktion zeigt den jeweiligen SensorDetailViewController VC an
    // als Parameter wird das jeweilige DeviceModel übergeben
    func showSensorDetailViewController(with device: DeviceModel) {
        
        let sensorDetail = SensorDetailViewController()
        sensorDetail.device = device
        
        navigationController?.pushViewController(sensorDetail, animated: true)
        
    }
    
    // Funktion zeigt den ScannerController VC an
    func showORScanner() {

        let qrcode = ScannerController()
        
        present(qrcode, animated: true, completion: nil)
    }
    
    // Funktion beendet den View
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // Funktion fragt User ob er
    // - Device anlegen möchte (Scanner)
    // - Beacon anlegen möchte
    func showOptions() {
        
        let noAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        let qrAction = UIAlertAction(title: "QR Code scannen", style: .default) { (action) in
            
            self.showORScanner()
        }
        
        let beaconAction = UIAlertAction(title: "iBeacon anlegen", style: .default) { (action) in
            
            self.showAddSensorController()
        }
        
        showAlertSheet(title: "", contentText: Constants.libraryOptionText, actions: [qrAction, beaconAction, noAction])
    }
    
    
    // Funktion für den Alarm der den User auffordert
    func showAlertSheet(title: String, contentText: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: contentText, preferredStyle: .actionSheet)
            for action in actions {
                alertController.addAction(action)
            }
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            if let presenter = alertController.popoverPresentationController {
                presenter.sourceView = self.addButton
                presenter.sourceRect = self.addButton.bounds
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // ------ VIEWS -----

    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nicht dabei? Hier können Sie den Sensor manuell hinzufügen."
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Hinzufügen", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(white: 0, alpha: 0.06)
        button.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        return button
    }()
    
    
    // ----- SETUP VIEWS ------
    
    func setupHeaderView() {
        
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = UIColor(white: 1, alpha: 1)
        
        view.addSubview(header)
        header.addSubview(addButton)
        header.addSubview(headlineLabel)
        
        header.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        headlineLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 20).isActive = true
        headlineLabel.widthAnchor.constraint(equalTo: header.widthAnchor, constant: -80).isActive = true
        headlineLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        
        addButton.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20).isActive = true
        addButton.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        
    }
    
}

// Delegate Methods von UICollectionViewDelegateFlowLayout
extension SensorLibraryController: UICollectionViewDelegateFlowLayout {
    
    // Funktion zum anzeigen der Cells im CollectionView
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorLibraryCell
        
        cell.device = Constants.devices[indexPath.item]
        
        return cell
    }
    
    // Funktion die die Anzahl der angzeigten Objekte in einer Section zurückgibt
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.devices.count
    }

    // Funktion gibt Anzahkl der Sections im CollectionView zurück
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Funktion gibt die Größe des Headers in der Section zurück
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 140)
        
    }
    
    // Funktion gibt die Größe jeder Cell zurück
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.bounds.size.width)
        
        return CGSize(width: itemWidth, height: 130)
    }
    
    // Funktion gibt an was passiert wenn man auf einer der Cells klickt
    // 1. Variable wird das markierte Objekt gespeichert
    // 2. Variable wird übergeben und der jeweilige VC wird angezeigt
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // In der Variable wird das markierte Objekt gespeichert
        let selected = Constants.devices[indexPath.item]
        
        // Variable wird übergeben und der jeweilige VC wird angezeigt
        showSensorDetailViewController(with: selected)
        
    }
    
}


