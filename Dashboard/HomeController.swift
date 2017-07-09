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
    // my ip eduroam 141.45.201.228
    var client: TCPClient?
    let host = "192.168.1.77"
    let port = 8080
    
    // cells & header id
    let headerId = "headerId"
    let cellId = "cellId"
    
    // timer
    var timer: Timer?
    
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
        
        conntectToServer()
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
    
    
    // shows qr code scanner vc
    func showORScanner() {
        
        let qrcode = ScannerController()
        let nav = UINavigationController(rootViewController: qrcode)
        
        present(nav, animated: true, completion: nil)
    }
    
    // button - add sensor manually
    func addSensorManually() {
        
        let layout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: SensorLibraryController(collectionViewLayout: layout))
        
        present(nav, animated: true, completion: nil)
    }
    
    // shows alert if event appears
    func showAlert(with event: EventModel, activated: Bool) {
        
        if activated {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlert(title: "ACHTUNG", contentText: "\(event.type)wert \(event.text.rawValue)", actions: [okAction])
        }
    }
    
    // current time string (short)
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
        
        checkDataFromServer()
        
        //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        //showAlert(title: "Zugang verweigert", contentText: Constants.adminAlarmText, actions: [okAction])
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
        backgroundView.addSubview(headerView)

        view.addSubview(HomeController.countLabel)
        view.addSubview(alarmButton)
        
        
        backgroundView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 135).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        headerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10).isActive = true
        headerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -20).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        headerView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10).isActive = true
        
        alarmButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 22).isActive = true
        alarmButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -5).isActive = true
        alarmButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        alarmButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        HomeController.countLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        HomeController.countLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        
    }
    
    
    
    
    
    // ------ views -------
    
    
    var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        view.layer.cornerRadius = 4
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
    
    
    static var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Keine Events"
        return label
    }()
    
    
    
    

}



    





