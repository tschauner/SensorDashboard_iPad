//
//  HeaderCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


class HeaderView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // init eventBar
    
    lazy var eventBar: EventsCV = {
        let eb = EventsCV()
        eb.translatesAutoresizingMaskIntoConstraints = false
        eb.headerView = self
        return eb
    }()
    
    
    // variables
    
    var eventView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        return v
    }()
    
    var sectionLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.textColor = .black
        lv.textAlignment = .left
        return lv
    }()
    
    var headlineLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.text = "Events"
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    
    // setup views

    func setupViews() {
        
        addSubview(eventView)
        eventView.addSubview(eventBar)
        addSubview(sectionLabel)
        
        eventView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        eventBar.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 50).isActive = true
        eventBar.leftAnchor.constraint(equalTo: eventView.leftAnchor).isActive = true
        eventBar.rightAnchor.constraint(equalTo: eventView.rightAnchor).isActive = true
        
        
        sectionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
    }
    
}
