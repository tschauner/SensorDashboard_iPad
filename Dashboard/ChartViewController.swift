//
//  ChartView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 17.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController, ChartDelegate {
    
    // hier min max values übergeben
    var minValue: Float = 0
    var maxValue: Float = 0
    var heightY = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.alpha = 0
        
        setupViews()
        
        initializeChart()
        
        setupNavBar()
        
    }
    
    var sensor: SensorModel? = nil {
        didSet {
            if let sensor = sensor {
                
                typeLabel.text = sensor.type
            }
        }
    }
    
    // property observer for sensors / geths 
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                // shows data of every device in Sensorview
                
                deviceImage.image = UIImage(named: device.image)
                deviceLabel.text = device.name
                
            }
        }
    }
    
    // -------- FUNCTIONS -------
    
    
    // make emergency call
    @objc func emergencyCall() {
        
        guard let number = URL(string: "telprompt://+491728601109") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
    
    
    // ------ SETUP VIEWS -------
    
    
    func makeFancyGraphChart(with frame: CGRect) {
        /**
         This is a description.
         
         - Road: For streets or trails.
         - Touring: For long journeys.
         - Cruiser: For casual trips around town.
         - Hybrid: For general-purpose transportation.
         */
        
        let graphView = ScrollableGraphView(frame: frame)
        graphView.backgroundFillColor = .darkGray
        graphView.rangeMax = 50
        graphView.shouldAdaptRange = true
        
        graphView.lineWidth = 2
        graphView.lineColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.5)
        graphView.lineStyle = .smooth
        
        graphView.shouldFill = true
        graphView.fillType = .gradient
        graphView.fillColor = UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.0)
        graphView.fillGradientType = .linear
        graphView.fillGradientStartColor = UIColor(red:0.25, green:0.84, blue:1.00, alpha:0.2)
        graphView.fillGradientEndColor = UIColor(red:0.15, green:0.64, blue:1.00, alpha:0.2)
        
        graphView.dataPointSpacing = 80
        graphView.dataPointSize = 4
        graphView.dataPointFillColor = UIColor.white
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 12)
        graphView.referenceLineColor = UIColor(white: 1, alpha: 0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.dataPointLabelColor = UIColor(white: 1, alpha: 0.5)
        
        
        let data: [Double] = [-20, -22, -10, 19, 20, 20, 20, 20, 19, 22, 22, 22, 22, 22, 25, 26, 29, 25, 19, 16, 10, 10, 9, 8, 8, 7, 3]
        let labels = ["one", "two", "three", "four", "five", "six", "four", "five", "six", "one", "two", "three", "four", "five", "six", "four", "five", "six", "one", "two", "three", "four", "five", "six", "four", "five", "six"]
        graphView.set(data: data, withLabels: labels)
        view.addSubview(graphView)
    }
    
    func makeGraphChart(with frame: CGRect) {
        
        let maxView = UIView()
        maxView.translatesAutoresizingMaskIntoConstraints = false
        maxView.backgroundColor = .red
        maxView.alpha = 1
        
        let maxLabel = UILabel()
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.font = UIFont.systemFont(ofSize: 12)
        maxLabel.textColor = .white
        
        let chart = Chart(frame: frame)
        
        //Set minimum and maximum values for y-axis
        chart.minY = -20
        chart.maxY = 40
        chart.labelColor = .white
        chart.lineWidth = 2
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1)) +  "ºC" }
        chart.delegate = self
        
        maxValue = chart.maxY!
        minValue = chart.minY!
        
        let data: [Float] = [-20, -10, -1, -22, 0, 19, 30, 30, 40, 42, 50, 25, 26, 29, 25, 19, 16, 10, 10, 9, 8, 8, 7, 3]
        
        let series = ChartSeries(data)
        series.area = true
        
        chart.add(series)
        
        view.addSubview(chart)
        view.addSubview(labelView)
        labelView.addSubview(valueLabel)
        view.bringSubview(toFront: labelView)
        
        valueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: labelView.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor).isActive = true
        
        
    }
    
    // init chart view
    func initializeChart() {
        
        let frame = CGRect(x: 15, y: view.frame.height - 650, width: view.frame.width - 30, height: 550)
        makeFancyGraphChart(with: frame)
    }
    
    // setup view for nav bar
    func setupNavBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        
        // remove the shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // show wiki page when button is clicked
    func showWikiController() {
        
        let wiki = WikiController()
        navigationController?.pushViewController(wiki, animated: true)
    }
    
    
    // if user toches the chart view
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.labelView.alpha = 1
        })
        
        
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            
            
            guard let min = chart.minY else { return }
            guard let max = chart.maxY else { return }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            valueLabel.text = numberFormatter.string(from: NSNumber(value: value))
            labelView.frame = CGRect(x: left - 25, y: 400, width: 80, height: 50)
            
            // label follows line
            //CGRect(x: left - 20, y: (view.frame.height - 180 - CGFloat(value*10)), width: 60, height: 30)
            
            switch (value, min, max) {
            case (value, _, max) where value > maxValue:
                valueLabel.textColor = .white
                labelView.backgroundColor = .red
            case (value, min, _) where value < minValue:
                valueLabel.textColor = .white
                labelView.backgroundColor = .blue
            default:
                valueLabel.textColor = .black
                labelView.backgroundColor = .white
            }
            
        }
    }
    
    // if user ends touching the chart view - label disappears
    func didEndTouchingChart(_ chart: Chart) {
        labelView.alpha = 0
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    
    // setup constraints for views
    func setupViews() {
        
        view.backgroundColor = .darkGray
        
        // subview stack
        view.addSubview(headerView)
        headerView.addSubview(deviceImage)
        headerView.addSubview(deviceLabel)
        headerView.addSubview(typeLabel)
        headerView.addSubview(descriptionLabel)
        headerView.addSubview(emergencyButton)
        headerView.addSubview(wikiButton)
        
        // setup constraints
        headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        deviceImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50).isActive = true
        deviceImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        deviceImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        deviceImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        deviceLabel.topAnchor.constraint(equalTo: deviceImage.topAnchor, constant: 10).isActive = true
        deviceLabel.leftAnchor.constraint(equalTo: deviceImage.rightAnchor, constant: 20).isActive = true
        
        typeLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor, constant: 5).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: deviceLabel.leftAnchor).isActive = true
        typeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        emergencyButton.topAnchor.constraint(equalTo: deviceImage.bottomAnchor, constant: 50).isActive = true
        emergencyButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -15).isActive = true
        emergencyButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        emergencyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        wikiButton.topAnchor.constraint(equalTo: emergencyButton.topAnchor).isActive = true
        wikiButton.rightAnchor.constraint(equalTo: emergencyButton.leftAnchor, constant: -10).isActive = true
        wikiButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        wikiButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    // ------ VIEWS -------
    
    
    var emergencyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("Techniker", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(emergencyCall), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    var wikiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("Wiki", for: .normal)
        button.setImage(UIImage(named: "wiki"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(showWikiController), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    var labelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
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
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "KR QUANTEC ultra"
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Die Sensorik in der Lebensmitteltechnik bzw. Lebensmittelanalytik, auch Lebensmittelsensorik, beschäftigt sich mit der Bewertung von Eigenschaften mit den Sinnesorganen."
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Temperatur"
        label.textColor = .black
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
    
    var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    
    
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
