//
//  iBeacon.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 01.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

    

extension HomeController: CLLocationManagerDelegate {
    
    
    // Funktion die alle Beacons in der Range angibt
    // - nächster Beacon in der Nähe wird in Variable gespeichert
    // - nächster Beacon wird an updateDistance übergeben
    // - updateDistance prüft ob beacon schon in Verwendung ist
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        if beacons.count > 0 {
            closestBeacon = beacons[0].minor.uint16Value
            updateDistance(beacons[0].proximity)
            
        } else {
            updateDistance(.unknown)
        }
    }
    
    
    // Funktion setzt beaconIsConnected auf true wenn der user in die Beacon Range kommt
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        beaconIsConnected = true
    }
    
    
    // Funktion setzt beaconIsConnected auf false wenn der user die Beacon Range verlässt
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        beaconIsConnected = false
    }
    
    
    // Funktion prüft anhand der Entfernung ob beaconIsConnected auf true oder false gesetzt wird
    // - hier kann die Entfernung festgelegt werden, in welcher Range ein Beacon erkannt werden soll
    func updateDistance(_ distance: CLProximity) {
        
        switch distance {
        case .unknown:
            beaconIsConnected = false
        case .near:
            beaconIsConnected = checkIfSensorIsInUse()
        case .immediate:
            beaconIsConnected = checkIfSensorIsInUse()
        case .far:
            print("far")
            
        }
        
    }
}
