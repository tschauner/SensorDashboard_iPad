//
//  ViewController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let resuableHeaderId = "resuableHeaderId"
    let cellId = "cellId"
    
    
    var tapped = false
    var eventsHeightConstraint: NSLayoutConstraint!
    var heightFromBottom: NSLayoutConstraint!
    var connectedDevice: SensorModel?
    
    var beaconDistance = ""
    let locationManager = CLLocationManager()
    
    var beaconIsConnected = false {
        didSet {
            if beaconIsConnected {
                openNewSensorView()
                print("true")
            } else {
                
                beaconIsConnected = false
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    
                    self.newSensorView.alpha = 0
                    
                }, completion: nil)
            }
        }
    }
    
    var nearestBeacon = 0

    
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
    
    
    
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor.orange
    let newGreen = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 0.2)
    
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "MyBeacon")
    
    
    // every minor value has its own device
    
    let myBeacons: [Int: DeviceModel] = [
        14042: DeviceModel(name: "KR QUANTEC ultra", sensors: [
            
            SensorModel(id: "ss", type: .Luftdruck, entity: .Luftdruck, value: 1013.25, minValue: 0, maxValue: 1050, time: "Heute: 13:10"),
            SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: -2, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", type: .Lautstärke, entity: .Lautstärke, value: 60, minValue: 0, maxValue: 50, time: "Heute: 13:10")]
            
            ,image: "roboter1"),
        
        6333: DeviceModel(name: "ABB IRB 5400", sensors: [
            
            SensorModel(id: "ss", type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 48.6, minValue: 0, maxValue: 150, time: "Heute: 13:10"),
            SensorModel(id: "ss", type: .Luftfeuchtigkeit, entity: .Luftfeuchtigkeit, value: 20, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: 52, minValue: 0, maxValue: 50, time: "Heute: 13:10")]
            
            , image: "roboter2"),
        
        
        6179: DeviceModel(name: "KR QUANTEC extra", sensors: [
            
            SensorModel(id: "ss", type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 105.6, minValue: 0, maxValue: 250, time: "Heute: 13:10"),
            SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: 52, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
            SensorModel(id: "ss", type: .Luftdruck, entity: .Luftdruck, value: 13.25, minValue: 20, maxValue: 2500, time: "Heute: 13:10")]
            
            , image: "roboter3")
    ]
    
    
    var incomingData = [SensorModel]() {
        didSet {
            
            // name des Sensors
            
            headerView.sectionLabel.text = device?.name
            
            collectionView?.reloadData()
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Dashboard"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(eventButton))
        
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        setupCollectionView()

        setupHeaderView()
        
        initTapGesture()
        
        if tapped {
            collectionView?.contentOffset.y = -150
        } else {
            collectionView?.contentOffset.y = -70
        }
        
        
        
//        getDataFromJsonFile()
        
    }
    
    
    
    func getDataFromJsonFile() {
        
        do {
            if let file = Bundle.main.url(forResource: "Mock", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    
                    for obj in object {
                        
                        if let sensorId = obj["sensorid"] as? String,
                            let value = obj["value"] as? Int,
                            let min = obj["min"] as? Int,
                            let max = obj["max"] as? Int,
                            let time = obj["timestamp"] as? String {
                            
                            
                            switch sensorId {
                            case "28-01161575bfee":
                                
                                // section for every entity?
                                
                                print("")
                                
                            case "fake02":
                                
                                print("")
                            case "fake01":
                                
                                print("")
                                
                            default:
                                print("")
                            }
                            
                            
                        }
                        
                    }
                }
            }
            
        } catch {
            print("Error deserializing JSON: \(error)")
        }
    }
    
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: 180, height: 150)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(SensorCellTile.self, forCellWithReuseIdentifier: cellId)
    }
    
    // init headerView
    
    var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var touchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = .darkGray
        return view
    }()
    
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        label.text = "Sensor XY"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var sensorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperatur, Druck, Helligkeit"
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
    
    let plugView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.image = UIImage(named: "plug")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFill
        return view
    }()
    

    let deviceImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.contentMode = .scaleToFill
        return view
    }()
    
    
    
    // setup headerView
    
    func initTapGesture() {
        
        let pan = UITapGestureRecognizer(target: self, action: #selector(expandHeader))
        touchView.addGestureRecognizer(pan)
        
    }
    
    func expandHeader(tap: UITapGestureRecognizer) {
        
        tapped = !tapped
        
        eventAnimation()

    }
    

    
    func setupHeaderView() {
        

        let eventLabel = UILabel()
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.text = "Events"
        eventLabel.font = UIFont.boldSystemFont(ofSize: 16)
        eventLabel.textColor = .white
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(headerView)
        view.addSubview(touchView)
        touchView.addSubview(eventLabel)
        touchView.addSubview(HomeController.countLabel)
        touchView.addSubview(alarmButton)
        
        eventsHeightConstraint =  headerView.heightAnchor.constraint(equalToConstant: 50)
        eventsHeightConstraint.isActive = true
        
        backgroundView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 115).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        headerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10).isActive = true
        headerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -20).isActive = true
        headerView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10).isActive = true
        
        touchView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        touchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        touchView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        touchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        eventLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        eventLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
        
        alarmButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 22).isActive = true
        alarmButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -5).isActive = true
        alarmButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        alarmButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        
        HomeController.countLabel.leftAnchor.constraint(equalTo: eventLabel.rightAnchor, constant: 20).isActive = true
        HomeController.countLabel.centerYAnchor.constraint(equalTo: eventLabel.centerYAnchor).isActive = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tapped = false
        eventsHeightConstraint.constant = 50
        self.view.layoutIfNeeded()

    }
    
    // show viewcontroller with sensordata
    
    func show(sensorData: SensorModel) {
        
        let layout = UICollectionViewFlowLayout()
        let navSc = UINavigationController(rootViewController: SensorDetailController(collectionViewLayout: layout))
        
        present(navSc, animated: true, completion: nil)
    }
    
    
    // add event
    
    func eventButton() {
        
        beaconIsConnected = true
        

    
    }
    
    func eventAnimation() {
        
        eventsHeightConstraint.constant = tapped ? 130 : 50
        
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.collectionView?.contentOffset.y = self.tapped ? -150 : -70
                self.view.layoutIfNeeded()
                self.headerView.layoutIfNeeded()
        },
            completion: nil
        )
        
    }
    
    
    // current time string (short)
    
    func currentTimeString() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorCellTile
        
        cell.sensor = incomingData[indexPath.item]
        
        
        let va = cell.sensor?.value ?? 0
        let mi = cell.sensor?.minValue ?? 0
        let ma = cell.sensor?.maxValue ?? 50
        
        let time = currentTimeString()
        
        
        UIView.animate(withDuration: 0.8) {
            
            switch (va, mi, ma) {
            case let (value, _, max) where value > max:
                
                self.tapped = false
                cell.colorView.backgroundColor = self.maxColor
                cell.errorLabel.isHidden = false
                
                EventsCV.events.insert(EventModel(type: cell.sensor!.type.rawValue, time: time, text: .Max), at: 0)

                // wenn der wert größer als der max wert ist
                
            case let (value, min, _) where value < min:
                
                self.tapped = false
                cell.colorView.backgroundColor = self.minColor
                cell.errorLabel.isHidden = false
                
                EventsCV.events.insert(EventModel(type: cell.sensor!.type.rawValue, time: time, text: .Min), at: 0)
                
                // wenn der wert kleiner als der min wert ist
                
                
            default:
                cell.errorLabel.isHidden = true
                
            }
        }
        
        headerView.eventBar.collectionView.reloadData()
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if incomingData.count == 0 {
            
            collectionView.backgroundView = backGroundView()
            
            return 0
        } else {
            
            collectionView.backgroundView = UIView()
            return incomingData.count
            
        }
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        
        return CGSize(width: view.frame.width, height: 115)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.bounds.size.width  / 2)
        
        return CGSize(width: itemWidth-30, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // falls man mit der geklicken cell was anstellen will
        if let cell = collectionView.cellForItem(at: indexPath) as? SensorCellTile {
            
            
            let data = incomingData[indexPath.item]

            
            show(sensorData: data)
            
            
            
        }
        
    }

}


extension HomeController {
    
    func backGroundView() -> UIView {
        
        
        let containerView = UIView()
        containerView.frame = view.bounds
        containerView.center = CGPoint(x: view.center.x - 30, y: view.center.y)
        
        containerView.backgroundColor = .white
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        
        label.text = "Keine Sensoren\nin Reichweite"
        

        
        let size: CGFloat = 50
        let scalefactor: CGFloat = 8
        
        let shapeView = UIView(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size))
        shapeView.layer.borderWidth = 0.3
        shapeView.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
        shapeView.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        shapeView.layer.cornerRadius = 25
        shapeView.isHidden = true
        
        containerView.addSubview(shapeView)
        
        
        // first ring
        
        UIView.animate(withDuration: 1.8, delay: 0, options: [.curveEaseOut, .repeat], animations: {
            
            shapeView.isHidden = false
            shapeView.transform = CGAffineTransform(scaleX: scalefactor, y: scalefactor)
            shapeView.alpha = 0
            
        }, completion: nil)
        
        let shapeView2 = UIView(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size))
        shapeView2.layer.borderWidth = 0.3
        shapeView2.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        shapeView2.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
        shapeView2.layer.cornerRadius = 25
        shapeView2.isHidden = true
        
        containerView.addSubview(shapeView2)
        
        
        // second ring
        
        UIView.animate(withDuration: 1.8, delay: 2.5, options: [.curveEaseOut, .repeat], animations: {
            
            shapeView2.isHidden = false
            shapeView2.transform = CGAffineTransform(scaleX: scalefactor, y: scalefactor)
            shapeView2.alpha = 0
            
        }, completion: nil)


        containerView.addSubview(shapeView)
        containerView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 30).isActive = true
        label.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -100).isActive = true
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        return containerView
    }
    
}




