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
//    let id = "/141.45.208.222"
//    let port = 8080
//    var client: TCPClient?
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var connectedDevice: SensorModel?
    
    static var nearestBeacon = 0
    let locationManager = CLLocationManager()
    
    var closestBeacon: CLBeacon?
    var beaconIsConnected = false
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor.orange
    let newGreen = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 0.2)
    
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    
    
    //setup every device for detailed view
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                // shows data of every device in Sensorview
                
                
                deviceImage.image = UIImage(named: device.image)
                sensorNameLabel.text = device.name
                
                let sensors = device.sensors
                
                let sensorStrings = sensors.map { $0.type.rawValue }
                
                sensorLabel.text = sensorStrings.joined(separator: ", ")
                
            }
        }
    }
    
    
    // initial load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        
        addSensorsManuallyButton()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        
        setupCollectionView()

        setupHeaderView()
        
        setupNavBar()
        
        DispatchQueue.main.async {

        }
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        
    }
    
    // starts background view again & makes buttonview visible
    override func viewWillAppear(_ animated: Bool) {
        
        addSensorsManuallyButton()
        
        collectionView?.reloadData()
        
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
    
    func update() {
        
        updateCell(with: "sensor co2", sensor: SensorModel(id: "sensor co2", device: "ABC", type: .Temperatur, entity: .Temperatur, value: 152, minValue: 0, maxValue: 150, time: "12:55"))
    }
    
    
    func updateCell(with id: String, sensor: SensorModel) {
        
        guard let value = sensor.value else { return }
        guard let min = sensor.minValue else { return }
        guard let max = sensor.maxValue else { return }
        
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
            for row in 0..<Constants.sensorData.count {
                if Constants.sensorData[row].id == id {
                    indexPaths += [IndexPath(row: row, section: 0)]
            }
        }
        
        // Update beacon locations of visible rows.
        if let visibleRows = collectionView?.indexPathsForVisibleItems {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for item in rowsToUpdate {
                let cell = collectionView?.cellForItem(at: item) as! SensorTileCell
                cell.sensor?.value = sensor.value
                cell.refreshColor(value: value, min: min, max: max)
            }
        }
                
    }
    

    @objc func askSocketForData() {
        
        let sensorIds = Constants.sensorData.map { $0.id }
        
        Socket.sharedInstance.sendData(with: "GET / HTTP/1.0\n\n")
        
        
        
    }
    
    // show viewcontroller with sensordata
    func show(sensorData: SensorModel) {
        
        let chart = ChartView()
        
        UIView.animate(withDuration: 0.2) {
            self.buttonView.alpha = 0
        }
        
        navigationController?.pushViewController(chart, animated: true)
    }
    
    
    // add event
    func showORScanner() {
        
        let qrcode = ScannerController()
        let nav = UINavigationController(rootViewController: qrcode)
        
        present(nav, animated: true, completion: nil)
    }
    
    // button add sensor manually
    func addSensorManually() {
        
        let layout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: SensorLibraryController(collectionViewLayout: layout))
        
        present(nav, animated: true, completion: nil)
    }
    
    // shows alert if event appears
    func showAlert(with event: EventModel) {
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        showAlert(title: "ACHTUNG", contentText: "\(event.type)wert \(event.text.rawValue)", actions: [okAction])
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
    
    
    // setup navbar
    func setupNavBar() {
        
        
        // camera button
        let cameraButton = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showORScanner))
        cameraButton.tintColor = .darkGray
        navigationItem.leftBarButtonItem = cameraButton
        
        // profile Image in Nav
        let nameLabel = UIBarButtonItem(title: "Admin", style: .done, target: self, action: nil)
        nameLabel.tintColor = UIColor.darkGray
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "admin")
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 18
        
        profileImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        let background = UIView()
        background.backgroundColor = .gray
        background.frame = CGRect(x: 0, y: 0, width: 120, height: 35)
        background.layer.cornerRadius = 18
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "verbunden"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        background.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        
        let button = UIBarButtonItem(customView: background)
        
        
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
        backgroundView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        headerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10).isActive = true
        headerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -20).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        headerView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10).isActive = true
        
        alarmButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 22).isActive = true
        alarmButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -5).isActive = true
        alarmButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        alarmButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        
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
    
    var touchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
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
        button.setImage(UIImage(named: "alarm_pressed")?.withRenderingMode(.alwaysTemplate), for: UIControlState.highlighted)
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
    
    let newSensorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    var sensorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Keine Geräte in Reichweite"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var sensorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Keine"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Neues Gerät erkannt. Möchten Sie die Sensoren hinzufügen?"
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    let deviceImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.contentMode = .scaleToFill
        return view
    }()
    

}



    





