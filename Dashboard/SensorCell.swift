//
//  SensorCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class SensorTileCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    // transforms cell when pressed
    override var isHighlighted: Bool {
        didSet {
            self.transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.95) : CGAffineTransform.identity
        }
    }
    
    
    // init values in cell
    var sensor: SensorModel? = nil {
        didSet {
            if let sensor = sensor {
                
                let value = sensor.value ?? 0.0
                
                typeLabel.text = "\(sensor.type)"
                timeLabel.text = sensor.device
                valueLabel.text = "\(value)\(sensor.entity)"
                
                refreshColor(from: sensor)
                
            } else {
                typeLabel.text = ""
                timeLabel.text = ""
                valueLabel.text = ""
            }
        }
    }
    
    func refreshColor(from sensor: SensorModel) {
        
        UIView.animate(withDuration: 0.8) {
            
            switch self.getEmergencyCode(from: sensor) {
            case 1:
                // farbe ändern, alpha runter
                self.colorView.backgroundColor = Constants.minColor
                self.colorView.alpha = 0.3
                self.errorLabel.isHidden = false
            case 2:
                self.colorView.backgroundColor = Constants.minColor
                self.colorView.alpha = 0.6
                self.errorLabel.isHidden = false
            case 3:
                self.colorView.backgroundColor = Constants.minColor
                self.colorView.alpha = 1
                self.errorLabel.isHidden = false
                self.errorLabel.backgroundColor = .red
                self.errorLabel.textColor = .white
            case 4:
                self.colorView.backgroundColor = Constants.maxColor
                self.colorView.alpha = 0.3
                self.errorLabel.isHidden = false
            case 5:
                self.colorView.backgroundColor = Constants.maxColor
                self.colorView.alpha = 0.6
                self.errorLabel.isHidden = false
            case 6:
                self.colorView.backgroundColor = Constants.maxColor
                self.colorView.alpha = 1
                self.errorLabel.isHidden = false
                self.errorLabel.backgroundColor = .red
                self.errorLabel.textColor = .white
            default:
                self.errorLabel.isHidden = true
                self.colorView.alpha = 1
                self.colorView.backgroundColor = UIColor(white: 0.4, alpha: 1)
            }
        }
    }
    
    
    func getEmergencyCode(from sensor: SensorModel) -> Int {
        
        var valCode = 0
        guard let value = sensor.value else { return 0 }
        let exValue = sensor.exValue
        
        for ex in exValue {
            
            guard let exValue = ex?.value else { return 0 }
            guard let newCode = ex?.emergencyCode else { return 0 }
            guard let greater = ex?.greater else { return 0 }
            
            
            switch (value, greater, exValue) {
            case let (value, greater ,exValue) where greater && value >= exValue && newCode > valCode:
                print("true grösser")
                valCode = newCode
            case let (value, greater ,exValue) where !greater && value <= exValue && newCode > valCode:
                print("false grösser")
                valCode = newCode
            default:
                print("something went wrong")
            }
                
        }

        return valCode
        
    }
    
    
    // get current time as string
    func currentTimeString() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    // ------- VIEWS ---------
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
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
        lv.textColor = .black
        lv.text = "!"
        lv.isHidden = true
        lv.layer.cornerRadius = 10
        lv.clipsToBounds = true
        lv.backgroundColor = .yellow
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
    
    
    // --------- setup views ----------
    
    func setupViews() {
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.backgroundColor = UIColor(white: 0.4, alpha: 1)
        
        addSubview(colorView)
        
        colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        colorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 174).isActive = true
        
        self.addSubview(errorLabel)
        
        errorLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 40).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        
        self.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        self.addSubview(valueLabel)
        
        valueLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

