//
//  EventCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 03.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    var event: EventModel? = nil {
        didSet {
            if let event = event {
                
                textLabel.text = "\(event.type)swert \(event.text.rawValue)"
                timeLabel.text = event.time
                
            } else {
                textLabel.text = ""
                timeLabel.text = ""
            }
        }
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
