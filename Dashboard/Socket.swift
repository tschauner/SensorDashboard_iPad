//
//  Socket.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 01.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import Foundation
import UIKit
import SwiftSocket


class Socket {
    
    //Singleton
    public static let sharedInstance = Socket()
    
    fileprivate var tcpClient: TCPClient?
    
    // Property Observer Variable
    // - wenn connected backgroundColor und Title ändern sich
    public var connected: Bool = false {
        didSet {
            
            if connected {
                HomeController.connectButton.setTitle("Verbunden", for: .normal)
                HomeController.connectButton.backgroundColor = Constants.newGreen
            } else {
                HomeController.connectButton.setTitle("Verbinden", for: .normal)
                HomeController.connectButton.backgroundColor = UIColor(white: 0.4, alpha: 1)
                connected = false
            }

        }
    }
    
    // notwendiger Konstruktor
    public init() {
        
    }
    
    // Funktion zum Verbinden mit dem Server
    // - Timout von 10 Sek
    // - wenn erfolgreich, Text wird angezeigt
    // - gibt Rückgabewert zurück
    @discardableResult
    public func connect(with host: String, port: Int) -> Result {
        tcpClient = TCPClient(address: host, port: Int32(port))
        let result = tcpClient!.connect(timeout: 10)
        switch result {
        case .success:
            connected = true
            HomeController.eventLabel.text = "Verbindung erfolgreich hergestellt zu \(host)"
        case .failure(let error):
            HomeController.eventLabel.text = "\(error)"
        }
        
        return result
        
    }
    
    // Funktion zum Trennen der Verbindung zum Client
    public func disconnect() {
        if (connected) {
            tcpClient?.close()
            connected = false
        }
    }
}

extension Socket {
    
    // Funktion zum Senden von Strings an den Server
    // - gibt String zurück
    @discardableResult
    public func send(command: String) -> String {
        guard let res = tcpClient?.send(string: command) else { return "" }
        
        if (res.isSuccess) {
            guard let data = tcpClient?.read(1024*10) else { return "" }
            
            if (!data.isEmpty) {
                guard let response = String(bytes: data, encoding: .utf8) else { return ""}
                return response
            }
            return ""
        }
        else {
            guard let error = res.error?.localizedDescription else { return "" }
            return error
        }
    }
    
}
