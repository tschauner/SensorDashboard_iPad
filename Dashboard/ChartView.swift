//
//  ChartView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 17.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ChartView: UIViewController, ChartDelegate {
    
    
    func didFinishTouchingChart(_ chart: Chart) {
        
        self.labelView.alpha = 0
    }
    
    // hier min max values übergeben
    var minValue: Int = 0
    var maxValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.alpha = 0
        
        setupViews()
        
        initializeChart()
        
        setupNavBar()
        
    }
    
    // init chart view
    func initializeChart() {
        
        let chart = Chart(frame: CGRect(x: 15, y: view.frame.height - 720, width: view.frame.width - 30, height: 600))
        view.addSubview(chart)
        
        chart.delegate = self
        
        let data: [Float] = [0, -2, -1, -0, 0, 2, 4, 6, 8, 10, 20, 22, 22, 24, 25, 26, 29, 25, 19, 16, 10, 10, 9, 8, 8, 7, 3]
        
        let series = ChartSeries(data)
        series.area = true
        
        chart.add(series)
        
        // Set minimum and maximum values for y-axis
        chart.minY = -10
        chart.maxY = 50
        chart.labelColor = .white
        chart.lineWidth = 2
        
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1)) +  "ºC" }
        
        
        
    }
    
    // property observer for sensors / geths 
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                // shows data of every device in Sensorview
                
                deviceImage.image = UIImage(named: device.image)
                deviceLabel.text = device.name
                
                let sensors = device.sensors
                
                let sensorStrings = sensors.map { $0.type.rawValue }
                
                typeLabel.text = sensorStrings.joined(separator: ", ")
                
            }
        }
    }
    
    func setupNavBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        
        // remove the shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    var labelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    

    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.labelView.alpha = 1
        })
        
        
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            valueLabel.text = numberFormatter.string(from: NSNumber(value: value))
            labelView.frame = CGRect(x: left - 20, y: 220, width: 60, height: 30)
            
            
            
            
            
            
            
//            let constant = left - 430
//
//            valueLabel.frame.origin.x = constant
            
            
        }
    }
    
    func setupViews() {
        
        view.backgroundColor = .darkGray
        
        view.addSubview(deviceImage)
        view.addSubview(deviceLabel)
        view.addSubview(typeLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(labelView)
        labelView.addSubview(valueLabel)
        view.bringSubview(toFront: labelView)
        
        deviceImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        deviceImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        deviceImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        deviceImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        deviceLabel.topAnchor.constraint(equalTo: deviceImage.topAnchor, constant: 20).isActive = true
        deviceLabel.leftAnchor.constraint(equalTo: deviceImage.rightAnchor, constant: 20).isActive = true
        
        typeLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor, constant: 5).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: deviceLabel.leftAnchor).isActive = true
        typeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        valueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: labelView.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor).isActive = true
    }
    
    var deviceImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .yellow
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "roboter1")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        return image
        
    }()
    
    var deviceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "KR QUANTEC ultra"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Die Sensorik in der Lebensmitteltechnik bzw. Lebensmittelanalytik, auch Lebensmittelsensorik, beschäftigt sich mit der Bewertung von Eigenschaften mit den Sinnesorganen."
        label.textColor = UIColor(white: 0.9, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Temperatur"
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 14)
        lv.text = "Letzter Stand: 12:24"
        lv.textColor = .black
        lv.textAlignment = .right
        return lv
    }()
    
    var maxValueLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.red
        return l
    }()
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    
    func getStockValues() -> Array<Dictionary<String, Any>> {
        
        // Read the JSON file
        let filePath = Bundle.main.url(forResource: "Mock", withExtension: "json")
        let jsonData = try? Data(contentsOf: filePath!)
        let json: NSDictionary = (try! JSONSerialization.jsonObject(with: jsonData!, options: [])) as! NSDictionary
        let jsonValues = json["quotes"] as! Array<NSDictionary>
        
        // Parse data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let values = jsonValues.map { (value: NSDictionary) -> Dictionary<String, Any> in
            let date = dateFormatter.date(from: value["date"]! as! String)
            let close = (value["close"]! as! NSNumber).floatValue
            return ["date": date!, "close": close]
        }
        
        return values
        
    }
    

}
