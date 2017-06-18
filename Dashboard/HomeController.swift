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

class HomeController: UICollectionViewController {
    
    
    let detailView = SensorDetailViewController()
    
    let headerId = "headerId"
    let resuableHeaderId = "resuableHeaderId"
    let cellId = "cellId"
    
    var connectedDevice: SensorModel?
    
    static var nearestBeacon = 0
    let locationManager = CLLocationManager()
    
    var closestBeacon: CLBeacon?
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor.orange
    let newGreen = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 0.2)
    
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    
    
    
    // variables
    
    
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
    
    var beaconIsConnected = false {
        didSet {
            
        }
    }
    
    
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
    
    
    
    // every minor value has its own device
    
    // array with dummy data
    
//    let myBeacons: [Int: DeviceModel] = [
//
//        14042: DeviceModel(name: "KR QUANTEC ultra", sensors: [
//
//            SensorModel(id: "ss", type: .Luftdruck, entity: .Luftdruck, value: 1013.25, minValue: 0, maxValue: 1050, time: "Heute: 13:10"),
//            SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
//            SensorModel(id: "ss", type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10")]
//
//            ,image: "roboter1", uuid: ),
//
//        6333: DeviceModel(name: "ABB IRB 5400", sensors: [
//            
//            SensorModel(id: "ss", type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10"),
//            SensorModel(id: "ss", type: .Luftfeuchtigkeit, entity: .Luftfeuchtigkeit, value: 20, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
//            SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: 52, minValue: 0, maxValue: 50, time: "Heute: 13:10")]
//
//            , image: "roboter2"),
//
//
//        6179: DeviceModel(name: "KR QUANTEC extra", sensors: [
//
//            SensorModel(id: "ss", type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 105.6, minValue: 0, maxValue: 250, time: "Heute: 13:10"),
//            SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: 52, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
//            SensorModel(id: "ss", type: .Luftdruck, entity: .Luftdruck, value: 13.25, minValue: 20, maxValue: 2500, time: "Heute: 13:10")]
//
//            , image: "roboter3")
//    ]
    
    
    // array for collectionview
    
    var incomingData = [SensorModel]() {
        didSet {
            
            headerView.sectionLabel.text = device?.name
            collectionView?.reloadData()
        }
    }
    
    
    // initial load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSensorsManuallyButton()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        
        setupCollectionView()

        setupHeaderView()
        
        setupNavBar()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        addSensorsManuallyButton()
        
        if incomingData.isEmpty {
            collectionView?.backgroundView = backGroundView()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.buttonView.alpha = 1
        }
        
        
    }
    
    
    
    // setup collection view
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        collectionView?.backgroundColor = UIColor.darkGray
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(SensorTileCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // setup navbar
    
    func setupNavBar() {
        
        
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        
        // remove the shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isTranslucent = false
        
        // camera button
        let cameraButton = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showORScanner))
        cameraButton.tintColor = .darkGray
        navigationItem.leftBarButtonItem = cameraButton
        
        // profile Image in Nav
        let nameLabel = UIBarButtonItem(title: "Admin", style: .done, target: self, action: nil)
        nameLabel.tintColor = UIColor.darkGray
        
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "admin")
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        profileImageView.layer.cornerRadius = 18
        
        let rightBarButtonItem = UIBarButtonItem(customView: profileImageView)
        navigationItem.rightBarButtonItems = [rightBarButtonItem, nameLabel]
        
        
        
    }
    
    func saveSensor() {
        
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
        
        present(qrcode, animated: true, completion: nil)
    }
    
    
    func addSensorManually() {
        
        let layout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: SensorLibraryController(collectionViewLayout: layout))
        
        present(nav, animated: true, completion: nil)
    }
    
    func showAlert(with event: EventModel) {
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        showAlert(title: "Achtung", contentText: "\(event.type)swert \(event.text.rawValue)", actions: [okAction])
    }
    
    // current time string (short)
    
    func currentTimeString() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }

}



    





