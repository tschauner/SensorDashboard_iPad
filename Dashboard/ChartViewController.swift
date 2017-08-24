//
//  ChartView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 17.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import MessageUI

class ChartViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var timer = Timer()
    var deviceName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.alpha = 0
        
        setupViews()
        
        initializeChart()
        
        setupNavBar()
        
        sendDataWithTimer()
        
        getDeviceInformations(device: deviceName)
        
    }
    
    var extremeValue = [ExtremeValueModel?]()
    
    // Property Observer für das Sensor Model
    // - hier wird das SensorModel übergeben
    // - Daten werden safe entpackt
    // - Daten werden zugewiesen
    var sensor: SensorModel? = nil {
        didSet {
            if let sensor = sensor {
                typeLabel.text = sensor.type
                showAlarmFor(sensor: sensor)
            }
        }
    }
    
    // property observer for für das Device
    // da immer wieder bugs aufgetreten sind,
    // wurde helper funktion getDeviceInformations erstellt
    var device: DeviceModel? = nil {
        didSet {
//            if let device = device {
            
                // shows data of every device in Sensorview
//                descriptionLabel.text = device.description
//
//                deviceImage.image = UIImage(named: device.image)
//                deviceLabel.text = device.name
                
//            }
        }
    }
    
    // -------- FUNCTIONS -------
    
    
    // Funktion weist jedeweilige Informationen zum jeweiligen Device zu
    // Diese Funktion ist nur eine Helper Funktion, da es im Test immer wieder Fehler gab,
    // und einzelne Beschreibungstext gefehlt haben
    func getDeviceInformations(device: String) {
        
        switch device {
        case "KR QUANTEC ultra":
            descriptionLabel.text = Constants.devices[2].description
            deviceImage.image = UIImage(named: "roboter")
            deviceLabel.text = Constants.devices[2].name
        case "Serverraum 22B":
            descriptionLabel.text = Constants.devices[0].description
            deviceImage.image = UIImage(named: "server")
            deviceLabel.text = Constants.devices[0].name
        case "Gewächshaus 3 (Stevia)":
            descriptionLabel.text = Constants.devices[1].description
            deviceImage.image = UIImage(named: "plantage")
            deviceLabel.text = Constants.devices[1].name
        default:
            print("nix")
        }
    }
    
    
    // Funktion die zufällig Daten für das Chart zurückgibt
    private func generateRandomData(_ numberOfItems: Int, variance: Double, from: Double) -> [Double] {
        
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            
            let randomVariance = Double(arc4random()).truncatingRemainder(dividingBy: variance)
            var randomNumber = from
            
            if(arc4random() % 100 < 50) {
                randomNumber += randomVariance
            }
            else {
                randomNumber -= randomVariance
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    
    // Helper Funktion für den back Button
    // - weist dem Backbutton der automtisch erstellt wird, eine Funktion zu
    func back(sender: UIBarButtonItem) {
        
        timer.invalidate()
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // Funktion gibt den jeweiligen Emergencycode aus dem SensorModel zurück
    // - ExtremeValue aus dem Sensormodel entpacken
    // - jeweilige Extremevalue ausrechnen
    func getEmergencyCode(from sensor: SensorModel) -> Int {
        
        var valCode = 0
        guard let value = sensor.value else { return 0 }
        let exValue = sensor.exValue
        
        print(exValue)
        
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
    
    // Funktion zeigt Alarmlabel an, je nach ExtremeValueCode
    // - Wenn Code != 0 ist, Labels bleiben versteckt
    func showAlarmFor(sensor: SensorModel) {
        
        let type = sensor.type
        
        //value code wird nicht mitgeliefer
        let valCode = getEmergencyCode(from: sensor)
        
        let event = EventModel(type: type, time: "", text: Constants.errorCode[valCode])
        
        if valCode != 0 {
            errorLabel.isHidden = false
            errorView.isHidden = false
            emergencyButton.backgroundColor = .red
            emergencyButton.setTitleColor(UIColor.white, for: .normal)
            errorLabel.text = "Es wurde der \(event.text)"
            
        } else {
            errorLabel.isHidden = true
            errorView.isHidden = true
            emergencyButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
            emergencyButton.setTitleColor(UIColor.black, for: .normal)
        }
        
    }
    
    // Funktion die einen Funktion alle 5 sek aufruft
    func sendDataWithTimer() {
        
        if Socket.sharedInstance.connected {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.sendData), userInfo: nil, repeats: true)
            timer.fire()
        } else {
            timer.invalidate()
            
        }
    }
    
    // Funktion sendet die jeweilige SensorId als String und liest die JSON Datei aus
    // - Sensorid entpacken
    // - # an String anhängen
    // - Rückgabewert in Variable speichern
    // - Variable an readJsonToString Methode übergeben
    @objc func sendData() {
        
        guard let id = sensor?.id else { return }
        DispatchQueue.main.async {
            
            var sendId = id
            sendId.append("#")
            
            let result = Socket.sharedInstance.send(command: sendId)

            if result.isEmpty {
                print("json is empty")
            } else {
                self.readJsonToString(with: result)
            }
        }
    }
    
    
    // Funktion liest die JSON dateien aus und speichert die Werte in einem SensorModel
    func readJsonToString(with jsonStr: String) {
        
        guard let data = jsonStr.data(using: String.Encoding.ascii, allowLossyConversion: false) else { return }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = json as? [[String: Any]] else { return }
            
            for data in dict {
                
                if let sensorId = data["sensorID"] as? String,
                    let value = data["value"] as? String,
                    let timestamp = data["timestamp"] as? String {
                    
                    guard let exV = sensor?.exValue else { return }
                    
                    let newSensor = SensorModel(id: sensorId, device: "", type: "", entity: "", value: Float(value), time: timestamp, exValue: exV)
                
                    sensor? = newSensor
                }
            }
        }
        catch {
            print("Error deserializing JSON: \(error)")
        }
        
    }
    
    // Diese Funktion gibt einen Alarm aus, falls der User die Apple Mail App nicht installiert hat
    func showSendMailErrorAlert() {
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.showAlert(title: "Achtung", contentText: "Irgendetwas ist schief gelaufen.", actions: [action])
    }
    
    // Funktion zum Abbrechen der Email. Bringt User zurück zur App
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    // Funktion ruft hinterlegte Nummer an
    @objc func emergencyCall() {
        
        guard let number = URL(string: "telprompt://+491728601109") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
    
    // Funktion zum senden einer Email über Standard Email Programm
    @objc func sendFeedbackEmail() {
        // erst checken
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["techniker@sensor40.com"])
            mail.setSubject("Notiz zu Sensor \(sensor?.type ?? "")")
            mail.setMessageBody("<p>Neue Notiz</p>", isHTML: true)
            
            present(mail, animated: true)
            
        } else {
            self.showSendMailErrorAlert()
        }
    }
    

    // Funktion zum zufälligen erstellen von Labels für den ChartView
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    
    // Funktion zum initialisieren des ChartViees
    func initializeChart() {
        
        let frame = CGRect(x: 15, y: view.frame.height - 610, width: view.frame.width, height: 550)
        makeFancyGraphChart(with: frame)
    }
    
    // Funktion für das Anzeigen der NavigationBar und des Back Buttons
    func setupNavBar() {
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChartViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isTranslucent = false

    }
    
    // Funktion zeigt den WikiController an wenn der Button geklickt wird
    func showWikiController() {
        
        guard let deviceName = device?.id else { return }
        let wiki = WikiController()
        wiki.deviceName = deviceName
        navigationController?.pushViewController(wiki, animated: true)
    }
    
    // Funktion beendet den View und stoppt den Timer
    @objc func dismissView() {
        
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // ---- SETUP VIEWS -----
    
    
    // Funktion erstellt den ChartView mit ScrollView
    func makeFancyGraphChart(with frame: CGRect) {
        
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
        
        
        let data: [Double] = generateRandomData(30, variance: 4, from: 22)
        let labels = generateSequentialLabels(30, text: "Juni")
        graphView.set(data: data, withLabels: labels)
        view.addSubview(graphView)
    }
    
    
    // Erstellt alle Views im ViewController
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
        headerView.addSubview(errorView)
        headerView.addSubview(errorLabel)
        headerView.addSubview(noteButton)
        
        // setup constraints
        headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        deviceImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50).isActive = true
        deviceImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        deviceImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        deviceImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        deviceLabel.topAnchor.constraint(equalTo: deviceImage.topAnchor).isActive = true
        deviceLabel.leftAnchor.constraint(equalTo: deviceImage.rightAnchor, constant: 20).isActive = true
        
        typeLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor, constant: 5).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: deviceLabel.leftAnchor).isActive = true
        typeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        emergencyButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        emergencyButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -15 ).isActive = true
        emergencyButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        emergencyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        noteButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        noteButton.rightAnchor.constraint(equalTo: emergencyButton.leftAnchor, constant: -10).isActive = true
        noteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        noteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        wikiButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        wikiButton.rightAnchor.constraint(equalTo: noteButton.leftAnchor, constant: -10).isActive = true
        wikiButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        wikiButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        errorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        errorView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        errorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        errorLabel.leftAnchor.constraint(equalTo: errorView.rightAnchor, constant: 10).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
    }
    
    
    // ------ VIEWS -------
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var errorView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "!"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .yellow
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    
    var emergencyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Techniker", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(emergencyCall), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    var noteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Notiz", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendFeedbackEmail), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    var wikiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Wiki", for: .normal)
        button.setImage(UIImage(named: "wiki"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
        label.font = UIFont.systemFont(ofSize: 15)
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
