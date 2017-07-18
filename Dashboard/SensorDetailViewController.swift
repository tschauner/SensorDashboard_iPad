//
//  SensorDetailViewController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 15.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


class SensorDetailViewController: UIViewController {
    
    var sensors = [SensorModel]()
    var sensorStrings = [String]()
    
    // set up all views
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                // shows data of every device in Sensorview
                deviceImage.image = UIImage(named: device.image)
                sensorNameLabel.text = device.name
                
                sensors = device.sensors
                
                sensorStrings = sensors.map { $0.type }
                
                sensorLabel.text = sensorStrings.joined(separator: ", ")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavbar()
        
    }
    
    func dismissView() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // saves selected sensors
    func saveSensor() {
        
        let layout = UICollectionViewFlowLayout()
        let home = HomeController(collectionViewLayout: layout)
        home.devices.append(device!)
        home.beaconsFound.append(device!.minorValue)
        home.conntectToServer()
        
        let nav = UINavigationController(rootViewController: home)
        
        present(nav, animated: true, completion: nil)
        
        
    }
    
    
    // ------- SETUP VIEWS ---------
    
    
    func setupNavbar() {
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = closeButton
    }

    func setupViews() {
        
        view.backgroundColor = .white
        
        // subview stack
        view.addSubview(deviceImage)
        view.addSubview(line)
        view.addSubview(headlineLabel)
        view.addSubview(sensorIcon)
        view.addSubview(sensorLabel)
        view.addSubview(describtionLabel)
        view.addSubview(okButton)
        
        guard let deviceString = device?.name else { return }
        
        headlineLabel.text = "\(deviceString) enthält \(sensorStrings.count) Sensoren."
        
        // setup constraints for views
        deviceImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        deviceImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        deviceImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deviceImage.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        line.topAnchor.constraint(equalTo: deviceImage.bottomAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        headlineLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 30).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        headlineLabel.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        sensorIcon.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20).isActive = true
        sensorIcon.leftAnchor.constraint(equalTo: headlineLabel.leftAnchor, constant: -10).isActive = true
        sensorIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sensorIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        sensorLabel.centerYAnchor.constraint(equalTo: sensorIcon.centerYAnchor).isActive = true
        sensorLabel.leftAnchor.constraint(equalTo: sensorIcon.rightAnchor, constant: 10).isActive = true
        
        describtionLabel.topAnchor.constraint(equalTo: sensorLabel.bottomAnchor, constant: 30).isActive = true
        describtionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        describtionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        
        okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        okButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    
    // ---------- VIEWS ---------
    
    var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("Hinzufügen", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(saveSensor), for: .touchUpInside)
        return button
    }()
    
    
    let header: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    var sensorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Keine Geräte in Reichweite"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var sensorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Keine"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    var describtionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    
    let deviceImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.contentMode = .scaleToFill
        return view
    }()
    
    
    let sensorIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .cyan
        image.image = UIImage(named: "sensorIcon")?.withRenderingMode(.alwaysOriginal)
        return image
    }()
}
