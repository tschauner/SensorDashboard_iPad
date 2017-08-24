//
//  SearchSensorCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 11.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SensorLibraryCell: UICollectionViewCell, CLLocationManagerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        initLocationService()
        
    }
    
    // Property Observer für die Cells
    // 1. wenn die Cell gehiglightet ist, background = grau, ansonsten weiss
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? UIColor(white: 0.95, alpha: 1) : UIColor.white
        }
    }
    
    // location Manager Object
    let locationManager = CLLocationManager()
    
    // UUID String der Beacons. Der String ist je nach Hersteller unterschiedlich
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    
    
    // -----  VIEWS ------
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "test"
        label.textAlignment = .left
        return label
    }()
    
    var rangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Location: Unbekannt"
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    

    var descriptionLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .black
        lv.textAlignment = .right
        return lv
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "noImage")
        image.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var seperatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    // Property Observer für DeviceModel
    // 1. wenn das Device.image leer ist - setze ein dummy Bild
    // 2. ansonsten setze das übergebene Bild + Text
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                if device.image.isEmpty {
                    imageView.image = UIImage(named: "noImage")
                } else {
                    imageView.image = UIImage(named: device.image)
                }
                
                nameLabel.text = device.name
                
            }
        }
    }
    
    // ------- FUNCTIONS ---------
    
    
    // Initialisierung des Locationsmanagers
    // 1. Wenn die App zum ersten Mal gestartet wird, Authorisierung für die Benutzung notwendig
    // 2. Location wird nur abgefragt wenn App in Verwendung ist (requestWhenInUseAuthorization)
    func initLocationService() {
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
    }
    
    // Funktion zeigt an ob ein oder mehrere Beacons sich in der Nähe befinden
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        guard let d = device?.minorValue else { return }
        
        // 1. speichert den nächsten Beacon in der var closestBeacon
        // 2. vergleicht den Minorvalue vom closestBeacon und device Beacon (d)
        // 3. wenn beide Beacons den gleichen Value haben, wird die Entfernung (proximity) übergeben
        // 4. die Entfernung wird in Meter ausgegeben mit (makeStringOutof)
        if beacons.count > 0 {
            let closestBeacon = beacons[0] as CLBeacon
            if d.hashValue == closestBeacon.minor.intValue {
                makeStringOutOf(beacons[0].proximity, beacon: closestBeacon)
            }
        } else {
            makeStringOutOf(beacons[0].proximity, beacon: beacons[0])
        }
    }
    
    // Funktion berechnet die Entfernung der Beacons in Metern
    // 1. CLProximity und CLBeacon werden übergeben
    // 2. Entfernung wird in Metern im rangeLabel angezeigt
    func makeStringOutOf(_ distance: CLProximity, beacon: CLBeacon) {
        UIView.animate(withDuration: 0.8) {
            
            let accuracy = String(format: "%.2f", beacon.accuracy)
            
            switch distance {
            case .unknown:
                self.rangeLabel.text  = "Location Unbekannt"
            case .far:
                self.rangeLabel.text  = "Ca \(accuracy) Meter entfernt"
            case .near:
                self.rangeLabel.text  = "Ca \(accuracy) Meter entfernt"
            case .immediate:
                self.rangeLabel.text  = "Ca \(accuracy) Meter entfernt"
            }
        }
    }
    
    
    
    
    
    // ----- SETUP VIEWS ------
    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(rangeLabel)
        addSubview(seperatorLine)
        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -10).isActive = true
        
        rangeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        rangeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        
        seperatorLine.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        seperatorLine.leftAnchor.constraint(equalTo: rangeLabel.leftAnchor).isActive = true
        seperatorLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


