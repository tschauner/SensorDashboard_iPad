//
//  NewSensorView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 28.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation



extension HomeController {
    
    
    
    // saves sensors which belong to device
    
    func saveSensor() {
        
        beaconIsConnected = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            self.newSensorView.alpha = 0
            
        }, completion: nil)
        
        guard let sensors = device?.sensors else { return }
        
        for sensor in sensors {
            
            incomingData.append(sensor)
        }
    }
    
    // should open if a new sensor was found
    
    func openNewSensorView() {
        
        
        let okButton = UIButton(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitleColor(UIColor.black, for: .normal)
        okButton.setTitle("Hinzufügen", for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        okButton.addTarget(self, action: #selector(saveSensor), for: .touchUpInside)

        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = .white
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(white: 0.5, alpha: 1)
        
        let sensorIcon = UIImageView()
        sensorIcon.translatesAutoresizingMaskIntoConstraints = false
        sensorIcon.tintColor = .white
        sensorIcon.image = UIImage(named: "sensorIcon")?.withRenderingMode(.alwaysTemplate)

        
        // subview stack
        self.navigationController?.view.addSubview(newSensorView)
        newSensorView.addSubview(header)
        header.addSubview(headlineLabel)
        newSensorView.addSubview(deviceImage)
        newSensorView.addSubview(line)
        newSensorView.addSubview(sensorNameLabel)
        newSensorView.addSubview(sensorIcon)
        newSensorView.addSubview(sensorLabel)
        newSensorView.addSubview(okButton)


        // little haptic feedback
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        
        // main frame
        newSensorView.frame = view.bounds
        newSensorView.alpha = 0
        
        header.topAnchor.constraint(equalTo: newSensorView.topAnchor).isActive = true
        header.bottomAnchor.constraint(equalTo: deviceImage.topAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: newSensorView.widthAnchor).isActive = true
        
        headlineLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 60).isActive = true
        headlineLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true

        deviceImage.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 40).isActive = true
        deviceImage.widthAnchor.constraint(equalTo: newSensorView.widthAnchor).isActive = true
        deviceImage.centerXAnchor.constraint(equalTo: newSensorView.centerXAnchor).isActive = true
        deviceImage.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        line.topAnchor.constraint(equalTo: deviceImage.bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: newSensorView.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.leftAnchor.constraint(equalTo: newSensorView.leftAnchor).isActive = true
        
        sensorNameLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        sensorNameLabel.leftAnchor.constraint(equalTo: newSensorView.leftAnchor, constant: 40).isActive = true
        sensorNameLabel.widthAnchor.constraint(equalTo: newSensorView.widthAnchor, constant: -40).isActive = true
        
        sensorIcon.topAnchor.constraint(equalTo: sensorNameLabel.bottomAnchor, constant: 10).isActive = true
        sensorIcon.leftAnchor.constraint(equalTo: sensorNameLabel.leftAnchor, constant: -4).isActive = true
        sensorIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sensorIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        sensorLabel.centerYAnchor.constraint(equalTo: sensorIcon.centerYAnchor).isActive = true
        sensorLabel.leftAnchor.constraint(equalTo: sensorIcon.rightAnchor, constant: 10).isActive = true

        
        okButton.bottomAnchor.constraint(equalTo: newSensorView.bottomAnchor, constant: -20).isActive = true
        okButton.widthAnchor.constraint(equalTo: newSensorView.widthAnchor, constant: -100).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        okButton.centerXAnchor.constraint(equalTo: newSensorView.centerXAnchor).isActive = true

        

        
        
        // animates the view 1. label, 2. sensor 3. color
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            self.newSensorView.alpha = 1
            
        }, completion: nil)
        
        
        // animate label, y start values
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            generator.impactOccurred()
            
        }, completion: nil)
        
        
    }
    
    
    
}
