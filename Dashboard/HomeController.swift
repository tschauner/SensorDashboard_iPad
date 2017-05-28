//
//  ViewController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let resuableHeaderId = "resuableHeaderId"
    let cellId = "cellId"
    
    var tapped = false
    var eventsHeightConstraint: NSLayoutConstraint!
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor(red: 195/255, green: 14/255, blue: 26/255, alpha: 1)
    

    var incomingData = [SensorModel]() {
        didSet {
            
            switch (incomingData.count) {
            case 0:
                headerView.sectionLabel.text = ""
                
            default:
                headerView.sectionLabel.text = "\(incomingData.count) Sensoren in Reichweite"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Dashboard"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(eventButton))
        
      
        setupCollectionView()

        setupHeaderView()
        
        initTapGesture()
        
        if tapped {
            collectionView?.contentOffset.y = -150
        } else {
            collectionView?.contentOffset.y = -70
        }
        
    }
    
    
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 1)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        

        
        collectionView?.register(SensorCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // init headerView
    
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
    
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Keine Events"
        return label
    }()
    
    
    
//    override func viewDidLayoutSubviews() {
//        
//        // gradient layer for header
//        
//        let layer = CAGradientLayer()
//        layer.startPoint = CGPoint(x: 0.5, y: 0)
//        layer.endPoint = CGPoint(x: 0.5, y: 0.75)
//        let topColor = UIColor(red: 235/255, green: 103/255, blue: 122/255, alpha: 1).cgColor
//        let bottomColor = UIColor(red: 223/255, green: 63/255, blue: 85/255, alpha: 1).cgColor
//        
//        layer.frame = headerView.eventView.bounds
//        layer.colors = [topColor, bottomColor]
//        
//        headerView.eventView.clipsToBounds = true
//        headerView.eventView.layer.insertSublayer(layer, at: 0)
//        
//
//    }
    
    
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
        
        view.addSubview(headerView)
        view.addSubview(touchView)
        touchView.addSubview(eventLabel)
        touchView.addSubview(countLabel)
        touchView.addSubview(alarmButton)
        
        eventsHeightConstraint =  headerView.heightAnchor.constraint(equalToConstant: 50)
        eventsHeightConstraint.isActive = true

        
        headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
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
        
        countLabel.leftAnchor.constraint(equalTo: eventLabel.rightAnchor, constant: 20).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: eventLabel.centerYAnchor).isActive = true
        
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
        add(event: EventModel(time: "12:04", text: .TemperaturMax))
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
    
    // add events manually to collectionView
    
    func add(event: EventModel) {
        
        tapped = false
        
        eventAnimation()

        let newEvent = event
        EventsCV.events.insert(newEvent, at: 0)
        headerView.eventBar.collectionView.reloadData()
        incomingData.append(SensorModel(id: "12345", type: .Lautstärke, entity: .Lautstärke, value: 39, minValue: 0, maxValue: 50, time: "12:25"))


        switch EventsCV.events.count {
        case 0:
            countLabel.text = "Keine Events"
        case 1:
            countLabel.text = "\(EventsCV.events.count) Event"
        default:
            countLabel.text = "\(EventsCV.events.count) Events"
        }
        if EventsCV.events.count != 0 {
            countLabel.text = "\(EventsCV.events.count) Events"
        }
        
        self.collectionView?.reloadData()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorCell
        
        let sensor = incomingData[indexPath.item]
        

            let va = sensor.value ?? 0
            let mi = sensor.minValue ?? 0
            let ma = sensor.maxValue ?? 50
        
            switch (va, mi, ma) {
            case let (value, _, max) where value > max:
                print("ist größer")
                cell.timeLabel.text = sensor.time
                cell.typeLabel.text = sensor.type.rawValue
                cell.valueLabel.text = "\(value)\(sensor.entity.rawValue)"
                cell.colorView.backgroundColor = maxColor
                cell.messageLabel.text = "Maximalwert wurde überschritten"
                // wenn der wert größer als der max wert ist
                
            case let (value, min, _) where value < min:
                print("ist kleiner")
                cell.timeLabel.text = sensor.time
                cell.typeLabel.text = sensor.type.rawValue
                cell.valueLabel.text = "\(value)\(sensor.entity.rawValue)"
                cell.colorView.backgroundColor = minColor
                cell.messageLabel.text = "Minimalwert wurde unterschritten"
                // wenn der wert kleiner als der min wert ist
            
                
            default:
                print("ist normal")
                cell.timeLabel.text = sensor.time
                cell.typeLabel.text = sensor.type.rawValue
                cell.valueLabel.text = "\(va)\(sensor.entity.rawValue)"

        }


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
    
        
        return CGSize(width: view.frame.width, height: 110)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // falls man mit der geklicken cell was anstellen will
        if let cell = collectionView.cellForItem(at: indexPath) as? SensorCell {
            
            
            let data = incomingData[indexPath.item]

            
            show(sensorData: data)
            
            
            
        }
        
    }

}

extension HomeController {
    
    func backGroundView() -> UIView {
        
        
        let containerView = UIView()
        containerView.frame = view.bounds
        containerView.center = CGPoint(x: view.center.x - 20, y: view.center.y)
        
        containerView.backgroundColor = .white
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        
        label.text = "Keine Sensoren\nin Reichweite"
        

        
        let size: CGFloat = 50
        
        let shapeView = UIView(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size))
        shapeView.layer.borderWidth = 0.3
        shapeView.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        shapeView.layer.cornerRadius = 25
        
        containerView.addSubview(shapeView)
        
        
        // first ring
        
        UIView.animate(withDuration: 1.8, delay: 0.4, options: [.curveEaseOut, .repeat], animations: {
            
            shapeView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
            shapeView.alpha = 0
            
        }, completion: nil)
        
        let shapeView2 = UIView(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size))
        shapeView2.layer.borderWidth = 0.3
        shapeView2.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        shapeView2.layer.cornerRadius = 25
        
        containerView.addSubview(shapeView2)
        
        
        // second ring
        
        UIView.animate(withDuration: 1.8, delay: 1.5, options: [.curveEaseOut, .repeat], animations: {
            
            shapeView2.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
            shapeView2.alpha = 0
            
        }, completion: nil)


        containerView.addSubview(shapeView)
        containerView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 30).isActive = true
        

        
        
        
        return containerView
    }
    
}




