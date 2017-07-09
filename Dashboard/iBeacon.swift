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
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        region.notifyEntryStateOnDisplay = true
        
        if beacons.count > 0 {
            closestBeacon = beacons[0].minor.uint16Value
            updateDistance(beacons[0].proximity)
            
            
        } else {
            updateDistance(.unknown)
        }
    }
    
    
    // if user enters beacon range
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        beaconIsConnected = true
        print("conected")
    }
    
    
    // if user exits beacon range
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        beaconIsConnected = false
        print("deconnected")
        
        // removes data when beacon is out of range
        
        collectionView?.reloadData()
        
        EventsCV.events.removeAll()
        headerView.eventBar.collectionView.reloadData()
        
        // device name
        
        let content = UNMutableNotificationContent()
        
        content.title = "name"
        content.body = "Verbindung getrennt"
        content.sound = .default()
        
        
        let request = UNNotificationRequest(identifier: "ForgetMeNot", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    // for another use later
    func updateDistance(_ distance: CLProximity) {
        
        
        switch distance {
        case .unknown:
            
            beaconIsConnected = false
            
        case .near:
            beaconIsConnected = checkIfSensorIsInUse()
        case .immediate:
            beaconIsConnected = checkIfSensorIsInUse()
        case .far:
            beaconIsConnected = checkIfSensorIsInUse()
            
            
            
        }
        
    }
}
