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
            colorView.transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.95) : CGAffineTransform.identity
        }
    }
    
    
    // init values in cell
    var sensor: SensorModel? = nil {
        didSet {
            if let sensor = sensor {
                
                guard let value = sensor.value else { return }
                
                typeLabel.text = "\(sensor.type)"
                timeLabel.text = sensor.device
                valueLabel.text = "\(value)\(sensor.entity.rawValue)"
                
                refreshColor(from: sensor)
                
            } else {
                typeLabel.text = ""
                timeLabel.text = ""
                valueLabel.text = ""
            }
        }
    }
    
    // refresh backgroundColor depending on value
    func refreshColor(from sensor: SensorModel) {
        
        guard let value = sensor.value else { return }
        guard let min = sensor.minValue else { return }
        guard let max = sensor.maxValue else { return }
        
        print("max: ", max)
        
        UIView.animate(withDuration: 0.8) {
            
            switch (value, min, max) {
            case let (value, _, max) where value > max:
                
                self.colorView.backgroundColor = Constants.maxColor
                self.errorLabel.isHidden = false
                self.valueLabel.text = "\(value)\(self.sensor!.entity.rawValue)"
                
                // wenn der wert größer als der max wert ist
                
            case let (value, min, _) where value < min:
                
                self.colorView.backgroundColor = Constants.minColor
                self.errorLabel.isHidden = false
                self.valueLabel.text = "\(value)\(self.sensor!.entity.rawValue)"
                

                // wenn der wert kleiner als der min wert ist
                
                
            default:
                self.errorLabel.isHidden = true
                self.colorView.backgroundColor = UIColor(white: 0.4, alpha: 1)
                
            }
        }
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
    
    
    // --------- setup views ----------
    
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

