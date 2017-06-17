//
//  SearchSensorCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 11.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

class SensorLibraryCell: UICollectionViewCell, CLLocationManagerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? UIColor(white: 0.95, alpha: 1) : UIColor.white
        }
    }
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    var closestBeacon: CLBeacon?
    var location: String?
    
    // Variables
    
    var nameLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 18)
        lv.textColor = .black
        lv.text = "test"
        lv.textAlignment = .left
        return lv
    }()
    
    var rangeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 16)
        lv.textColor = .gray
        lv.textAlignment = .right
        return lv
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
        image.image = UIImage(named: "bulb")?.withRenderingMode(.alwaysTemplate)
        image.backgroundColor = .gray
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
    
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                
                imageView.image = UIImage(named: device.image)
                nameLabel.text = device.name
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        region.notifyEntryStateOnDisplay = true
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.rangeLabel.text  = "Location: Unbekannt"
                
            case .far:
                self.rangeLabel.text  = "Location: Weit"
                
            case .near:
                self.rangeLabel.text = "Location: In der Nähe"
                
            case .immediate:
                self.rangeLabel.text  = "Location: Unmittelbar"
            }
        }
    }
    
    
    // setup views
    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(rangeLabel)
        addSubview(seperatorLine)
        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
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


