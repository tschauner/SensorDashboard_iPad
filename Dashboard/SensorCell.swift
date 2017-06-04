//
//  SensorCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class SensorCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            colorView.transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.95) : CGAffineTransform.identity
        }
    }
    
    
    // init text

    var sensor: SensorModel? = nil {
        didSet {
            if let sensor = sensor {
                
                guard let value = sensor.value else { return }
                
                typeLabel.text = "\(sensor.type)"
                timeLabel.text = sensor.time
                valueLabel.text = "\(value)\(sensor.entity.rawValue)"
                
            } else {
                typeLabel.text = ""
                timeLabel.text = ""
                valueLabel.text = ""
            }
        }
    }
    
    
    
    // Variables
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.backgroundColor = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 1)
        return v
        
    }()
    
    var typeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 20)
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var valueLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 55)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var messageLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "bulb")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var alertImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "alert")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.isHidden = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    // setup views
    
    func setupViews() {
        
        addSubview(colorView)
        
        colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        colorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        colorView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 20).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        
        colorView.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        colorView.addSubview(valueLabel)
        
        valueLabel.topAnchor.constraint(equalTo: colorView.topAnchor).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: typeLabel.rightAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -5).isActive = true
        

//        colorView.addSubview(messageLabel)
//        
//        messageLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor).isActive = true
//        messageLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SensorCellTile: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            colorView.transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.95) : CGAffineTransform.identity
        }
    }
    
    
    // init text
    
    var sensor: SensorModel? = nil {
        didSet {
            if let sensor = sensor {
                
                guard let value = sensor.value else { return }

                typeLabel.text = "\(sensor.type)"
                timeLabel.text = sensor.time
                valueLabel.text = "\(value)\(sensor.entity.rawValue)"
                
            } else {
                typeLabel.text = ""
                timeLabel.text = ""
                valueLabel.text = ""
            }
        }
    }
    
    
    
    // Variables
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.backgroundColor = UIColor(white: 0.4, alpha: 1)
        return v
        
    }()
    
    var typeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 20)
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var valueLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 25)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 12)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var errorLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.text = "!"
        lv.isHidden = true
        lv.layer.cornerRadius = 10
        lv.clipsToBounds = true
        lv.backgroundColor = .red
        lv.textAlignment = .center
        return lv
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "bulb")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var alertImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "alert")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.isHidden = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    // setup views
    
    func setupViews() {
        
        
        addSubview(colorView)

        colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        colorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 174).isActive = true
        
        colorView.addSubview(errorLabel)
        
        errorLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        colorView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 40).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        
        colorView.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        colorView.addSubview(valueLabel)
        
        valueLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true

        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


