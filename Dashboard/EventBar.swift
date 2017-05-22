//
//  EventBar.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class EventBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // init collectionView
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    static var events = [EventModel(time: "10:29", text: .TemperaturMax), EventModel(time: "11:40", text: .TemperaturMin)]
    
    var headerView: UICollectionReusableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        
        addSubview(collectionView)
        
        collectionView.reloadData()
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EventBar.events.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        
        let alarm = EventBar.events[indexPath.item]
        
        cell.timeLabel.text = alarm.time
        cell.textLabel.text = alarm.text.rawValue
        
        return cell
    }
    
    
    // cell size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 10)
    }
    
    // cell spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EventCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    // variables
    
    var textLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 12)
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 12)
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var seperatorLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return l
    }()
    
    
    // setup views
    
    func setupViews() {
        
        addSubview(textLabel)
        addSubview(timeLabel)
        addSubview(seperatorLine)
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 10).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        seperatorLine.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 3).isActive = true
        seperatorLine.leftAnchor.constraint(equalTo: timeLabel.leftAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperatorLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



