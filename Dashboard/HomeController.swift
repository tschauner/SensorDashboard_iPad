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

    var host: String?
    var port: Int?
    
    // Cell & Header ID
    let headerId = "headerId"
    let cellId = "cellId"
    
    let unityScheme = "UnitySensorApp://"
    
    // Timer
    static var timer = Timer()
    
    var events = [EventModel]()
    
    // Beacons
    var closestBeacon: CLBeaconMinorValue?
    let locationManager = CLLocationManager()
    static var allBeacons = [CLBeacon]()
    var beaconsFound = [CLBeaconMinorValue]()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    
    // Property Observer Bool
    // - wenn true dann wird User gefragt ob Sensor hinzugefügt werden soll
    var beaconIsConnected = false {
        didSet {
            
            if beaconIsConnected {
                promptUser()
            }
        }
    }
    
    // Alarm
    var alarmIsActivated = false
    
    // Property Observer Variable
    // - speichert alle Sensoren aus dem Device im Array
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    
        initLocationServices()
        
        initGestureRecognizer()

    }
    
    // Funktion wird geladen bevor ViewVC angezeigt wird
    // - startet den Timer
    // - fügt den AddButton hinzu
    // - läd den BackgroundView
    override func viewWillAppear(_ animated: Bool) {
        
        sendDataWithTimer()
        addSensorsManuallyButton()

        if Constants.sensorData.isEmpty {
            collectionView?.backgroundView = backGroundView()
        } else {
            collectionView?.reloadData()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.buttonView.alpha = 1
        }
        
    }
    
    
	// ---------- SETUP VIEWS ------------
    
    func setupViews() {
        
        view.backgroundColor = .darkGray
        
        addSensorsManuallyButton()
        
        setupCollectionView()
        
        setupHeaderView()
        
        setupNavBar()
        
    }
    
    // ----------- FUNCTIONS -----------
    
    
    // Funktion initialisiert die LongPressGesture zum verschieben der Cells
    func initGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        self.collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    // Funktion zum verschieben der Cells
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
    
    
    
    // Funktion öffnet die Unity App über eine Url
    func openUnityApp() {
        
        let url = URL(string: unityScheme)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    // Funktion öffnet den SensorLibraryViewController
    func addSensorManually() {
        
        let layout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: SensorLibraryController(collectionViewLayout: layout))
        
        present(nav, animated: true, completion: nil)
    }
    
    
    
    // Funktion gibt die aktuelle Zeit als String zurück
    func currentTimeString() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    
    // Funktion ändert den Alarmbutton wenn dieser gedrückt wird
    func alarmButtonPressed() {
        
        if alarmIsActivated {
            alarmButton.setBackgroundImage(UIImage(named:"alarm_pressed")?.withRenderingMode(.alwaysTemplate), for: .normal)
            alarmIsActivated = false
        } else {
            alarmButton.setBackgroundImage(UIImage(named:"alarm")?.withRenderingMode(.alwaysTemplate), for: .normal)
            alarmIsActivated = true
        }
    }
    
    // Funktion verbindet Socket mit dem Server
    func conntectButtonPressed() {
        
        if Socket.sharedInstance.connected {
            print("already connected")
        } else {
            conntectToServer()
        }
    }
    
    // Funktion initialisiert die LocationServices und Beacons
    // - holt sich die Erlaubnis die Location im Hintergrund (whenInUse) abzufragen
    func initLocationServices() {
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }
    
    
    // ---------- SETUP VIEWS ------------
    
    
    // Funktion zum initialisiertn des CollectionViews
    // - Frame, Scrollrichtung, Spacing, BackgroundColor wird festgelegt
    // - Cell wird registriert
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
    
    func showAdminSettings() {
        let admin = AdminController()
        
        UIView.animate(withDuration: 0.2) {
            self.buttonView.alpha = 0
        }
        navigationController?.pushViewController(admin, animated: true)
    }
    
    
    
    // Funktion für den NavBar View
    func setupNavBar() {
        
        // Camera Button (Unity App) in NavBar
        let cameraButton = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(openUnityApp))
        cameraButton.tintColor = .darkGray
        navigationItem.leftBarButtonItem = cameraButton
        
        // Profil Bild in NavBar
        let nameLabel = UIBarButtonItem(title: "Admin", style: .done, target: self, action: #selector(showAdminSettings))
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
    
    
    // Funktion fügt den Button zum manuellen hinzufügen der Sensoren hinzu
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
        
        // Subview Stack
        self.navigationController?.view.addSubview(buttonView)
        buttonView.addSubview(okButton)
        
        // Main frame
        buttonView.frame = CGRect(x: 0, y: frame.height - 90, width: width, height: height)
        
        okButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -20).isActive = true
        okButton.widthAnchor.constraint(equalTo: buttonView.widthAnchor, constant: -100).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        okButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
    }
    
    
    // Funktion zum erstellen der restlichen Views
    // - evenLabel
    // - AlarmButton
    // - connectButton
    func setupHeaderView() {
        
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(HomeController.eventLabel)
        backgroundView.addSubview(alarmButton)
        backgroundView.addSubview(HomeController.connectButton)
        
        backgroundView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        alarmButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        alarmButton.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -15).isActive = true
        alarmButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        alarmButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        HomeController.connectButton.centerYAnchor.constraint(equalTo: alarmButton.centerYAnchor).isActive = true
        HomeController.connectButton.rightAnchor.constraint(equalTo: alarmButton.leftAnchor, constant: -10).isActive = true
        HomeController.connectButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        HomeController.connectButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        HomeController.eventLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20).isActive = true
        HomeController.eventLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 35).isActive = true
        
    }
    
    
    
    // ------ VIEWS -------
    
    
    var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    static var eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    
    var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    var alarmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "alarm")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(alarmButtonPressed), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    static var connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.cornerRadius = 13
        button.backgroundColor = UIColor(white: 0.4, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Verbinden", for: .normal)
        button.addTarget(self, action: #selector(conntectButtonPressed), for: UIControlEvents.touchUpInside)
        return button
    }()
    


}



    





