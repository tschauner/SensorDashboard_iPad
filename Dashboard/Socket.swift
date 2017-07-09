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
    
    public var connected: Bool = false
    
    public init() {
        
    }
    
    @discardableResult
    public func connect(address: String, port: Int32) -> Result {
        tcpClient = TCPClient(address: address, port: port)
        let result = tcpClient!.connect(timeout: 10)
        switch result {
        case .success:
            connected = true
            print("Successfully connected to \(address)")
        case .failure(let error):
            print("\(error)")
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
    public func send(command: String) -> (result: Result?, data: String) {
        let res = tcpClient?.send(string: command)
        
        if (res?.isSuccess)! {
            guard let data = tcpClient?.read(1024*10) else { return (nil, "nil")}
            
            if (!data.isEmpty) {
                guard let response = String(bytes: data, encoding: .utf8) else { return (nil, "")}
                return (res, response)
            }
            return (res, "")
        }
        else {
            guard let error = res?.error?.localizedDescription else { return (nil, "")}
            return (res, error)
        }
    }
    
}
