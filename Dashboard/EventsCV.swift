//
//  EventBar.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class EventsCV: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // init collectionView
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    let cellId = "cellId"
    static var events = [EventModel]() {
        didSet {
            
            switch EventsCV.events.count {
            case 0:
                HomeController.countLabel.text = "Keine Events"
            case 1:
                HomeController.countLabel.text = "\(EventsCV.events.count) Event"
            default:
                HomeController.countLabel.text = "\(EventsCV.events.count) Events"
            }
            
        }
    }
    
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
        collectionView.heightAnchor.constraint(equalToConstant: 54).isActive = true

    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EventsCV.events.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        
        cell.event = EventsCV.events[indexPath.item]
        
        
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




