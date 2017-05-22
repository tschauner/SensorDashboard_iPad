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
    
    lazy var eventBar: EventBar = {
        let eb = EventBar()
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
        addSubview(sectionLabel)
        eventView.addSubview(headlineLabel)
        eventView.addSubview(eventBar)
        
        eventView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        eventView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        eventView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        eventView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        headlineLabel.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 10).isActive = true
        headlineLabel.leftAnchor.constraint(equalTo: eventView.leftAnchor, constant: 10).isActive = true
        
        eventBar.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 10).isActive = true
        eventBar.leftAnchor.constraint(equalTo: eventView.leftAnchor).isActive = true
        eventBar.rightAnchor.constraint(equalTo: eventView.rightAnchor).isActive = true
        eventBar.bottomAnchor.constraint(equalTo: eventView.bottomAnchor, constant: -10).isActive = true
        
        sectionLabel.bottomAnchor.constraint(equalTo: eventView.bottomAnchor, constant: 40).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        
    }
    
}
