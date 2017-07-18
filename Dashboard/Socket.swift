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
    
    let host = "141.45.211.190"
    let port: Int32 = 8080
    

    //Singleton
    public static let sharedInstance = Socket()
    
    fileprivate var tcpClient: TCPClient?
    
    public var connected: Bool = false
    
    public init() {
        
    }
    
    @discardableResult
    public func connect() -> Result {
        tcpClient = TCPClient(address: host, port: port)
        let result = tcpClient!.connect(timeout: 10)
        switch result {
        case .success:
            connected = true
            HomeController.eventLabel.text = "Successfully connected to \(host)"
        case .failure(let error):
            HomeController.eventLabel.text = "\(error)"
        }
        
        return result
        
    }
    
    public func disconnect() {
        if (connected) {
            print("Disconnected")
            tcpClient?.close()
            connected = false
        }
    }
}

extension Socket {
    
    @discardableResult
    public func send(command: String) -> String {
        let res = tcpClient?.send(string: command)
        
        if (res?.isSuccess)! {
            guard let data = tcpClient?.read(1024*10) else { return "" }
            
            if (!data.isEmpty) {
                guard let response = String(bytes: data, encoding: .utf8) else { return ""}
                return response
            }
            return ""
        }
        else {
            guard let error = res?.error?.localizedDescription else { return "" }
            return error
        }
    }
    
}
