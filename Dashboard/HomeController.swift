//
//  ViewController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import SwiftSocket

class HomeController: UICollectionViewController {
    
    //141.45.208.222
    var client: TCPClient?
    //let host = "192.168.1.77"
    
    // cells & header id
    let headerId = "headerId"
    let cellId = "cellId"
    
    // timer
    var timer = Timer()
    
    var events = [EventModel]()
    
    // beacons
    var closestBeacon: CLBeaconMinorValue?
    let locationManager = CLLocationManager()
    static var allBeacons = [CLBeacon]()
    var beaconsFound = [CLBeaconMinorValue]()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    
    var beaconIsConnected = false {
        didSet {
            
            if beaconIsConnected {
                promptUser()
            }
        }
        
    }
    
    // alarm
    var alarmIsActivated = true
    
    
    //setup every device for detailed view
    var devices = [DeviceModel]() {
        didSet {
            for device in devices {
                for sensor in device.sensors {
                    
                    Constants.sensorData.append(sensor)
                    collectionView?.reloadData()
                }
            }
        }
    }
    
    
    // initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    
        initLocationServices()
        
        initGestureRecognizer()
    
        
        
    }
    
    // starts background view again & makes buttonview visible
    override func viewWillAppear(_ animated: Bool) {
        
        addSensorsManuallyButton()
        EventsCV.events.removeAll()
    
        
        if Constants.sensorData.isEmpty {
            collectionView?.backgroundView = backGroundView()
        } else {
            collectionView?.reloadData()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.buttonView.alpha = 1
        }
        
    }
    
    
    
    
    // ----------- FUNCTIONS -----------
    
    
    // setup views
    func setupViews() {
        
        view.backgroundColor = .darkGray
        
        addSensorsManuallyButton()
        
        setupCollectionView()
        
        setupHeaderView()
        
        setupNavBar()
        
    }
    
    
    // init gestures
    func initGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        self.collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    // gesture states to move item in collection view
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }
    
    
    /// presents qr code scanner vc
    func showORScanner() {
        
        let qrcode = ScannerController()
        let nav = UINavigationController(rootViewController: qrcode)
        
        present(nav, animated: true, completion: nil)
    }
    
    /// presents sensor library vc
    func addSensorManually() {
        
        let layout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: SensorLibraryController(collectionViewLayout: layout))
        
        present(nav, animated: true, completion: nil)
    }
    
    /// shows alert if event appears and activated
    func showAlert(with event: EventModel, activated: Bool) {
        
        if activated {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "ACHTUNG", contentText: "\(event.type)wert \(event.text.rawValue)", actions: [okAction])
        }
    }
    
    func eventButtonPressed() {
        
        print("event button pressed")
        let tableViewController = UITableViewController()
        tableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        present(tableViewController, animated: true, completion: nil)
        
        let presenter = tableViewController.popoverPresentationController
        presenter?.sourceView = countLabelButton
        presenter?.sourceRect = countLabelButton.bounds
        presenter?.permittedArrowDirections = .left
    }
    
    
    
    
    /// current time string (short)
    func currentTimeString() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    
    // change alarm button icon if pressed and de/activates it
    func alarmButtonPressed() {
        
        if alarmIsActivated {
            alarmButton.setBackgroundImage(UIImage(named:"alarm_pressed")?.withRenderingMode(.alwaysTemplate), for: .normal)
            alarmIsActivated = false
        } else {
            alarmButton.setBackgroundImage(UIImage(named:"alarm")?.withRenderingMode(.alwaysTemplate), for: .normal)
            alarmIsActivated = true
        }
    }
    
    // init locations services for ibeacon
    func initLocationServices() {
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }
    
    
    
    
    // ---------- SETUP VIEWS ------------
    
    
    // setup collection view
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.collectionView?.frame = CGRect(x: 15, y: 0, width: view.frame.width - 30, height: view.frame.height)
        }
        
        collectionView?.backgroundColor = UIColor.darkGray
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(SensorTileCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    
    // if someone presses die Admin button
    func adminAlert() {
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(title: "Zugang verweigert", contentText: Constants.adminAlarmText, actions: [okAction])
    }
    
    
    // setup navbar
    func setupNavBar() {
        
        // camera button
        let cameraButton = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showORScanner))
        cameraButton.tintColor = .darkGray
        navigationItem.leftBarButtonItem = cameraButton
        
        // profile Image in Nav
        let nameLabel = UIBarButtonItem(title: "Admin", style: .done, target: self, action: #selector(adminAlert))
        nameLabel.tintColor = UIColor.darkGray
        
        let profileImageView = UIImageView()
        profileImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        profileImageView.image = UIImage(named: "admin")
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 18
        
        let rightBarButtonItem = UIBarButtonItem(customView: profileImageView)
        navigationItem.rightBarButtonItems = [rightBarButtonItem, nameLabel]
        
    }
    
    
    // setup button view
    func addSensorsManuallyButton() {
        
        
        guard let frame = navigationController?.view.frame else { return }
        let width: CGFloat = frame.width
        let height: CGFloat = 90
        
        let okButton = UIButton(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitleColor(UIColor.lightGray, for: .normal)
        okButton.setTitle("Manuell hinzufügen", for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        okButton.addTarget(self, action: #selector(addSensorManually), for: .touchUpInside)
        
        buttonView.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        
        
        // subview stack
        self.navigationController?.view.addSubview(buttonView)
        buttonView.addSubview(okButton)
        
        
        // main frame
        buttonView.frame = CGRect(x: 0, y: frame.height - 90, width: width, height: height)
        
        okButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -20).isActive = true
        okButton.widthAnchor.constraint(equalTo: buttonView.widthAnchor, constant: -100).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        okButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
    }
    
    
    // setup header - event bar
    func setupHeaderView() {
        
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(HomeController.eventLabel)
        backgroundView.addSubview(alarmButton)
        
        backgroundView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
//
//        headerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10).isActive = true
//        headerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -20).isActive = true
//        headerView.heightAnchor.constraint(equalToConstant: 125).isActive = true
//        headerView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10).isActive = true
        
        alarmButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        alarmButton.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -15).isActive = true
        alarmButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        alarmButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
//        countLabelButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
//        countLabelButton.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20).isActive = true
//        countLabelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        countLabelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        HomeController.eventLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20).isActive = true
        HomeController.eventLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 35).isActive = true
        
    }
    
    
    
    
    
    // ------ views -------
    
    
    var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    static var eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Nicht verbunden"
        label.textColor = .white
        return label
    }()
    
    
    var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    // init headerView
    var headerView: HeaderView = {
        let view = HeaderView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var alarmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "alarm")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(alarmButtonPressed), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    
     var countLabelButton: UIButton = {
        let label = UIButton(type: .system)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        label.setTitleColor(UIColor.white, for: .normal)
        label.backgroundColor = .red
        label.layer.cornerRadius = 15
        label.titleLabel?.textAlignment = .center
        label.setTitle("!", for: .normal)
        label.addTarget(self, action: #selector(eventButtonPressed), for: UIControlEvents.touchUpInside)
        return label
    }()
    
    
    
    
    

}



    





