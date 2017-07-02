//
//  Socket.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 29.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class AppSocket: NSObject, StreamDelegate {
    var inStream: InputStream? = nil
    var outStream: OutputStream? = nil
    
    static let sharedInstance = AppSocket()
    
    // "141.45.208.222", port 8080
    func connect(ipAdr: String, port: Int, status: Int) {
        print("client :connect ipAdr: \(ipAdr) port:\(port)")
        var tempInput: InputStream? = nil
        var tempOutput: OutputStream? = nil
        Stream.getStreamsToHost(withName: ipAdr, port: port, inputStream: &tempInput, outputStream: &tempOutput)
        
        self.inStream = tempInput!
        self.outStream = tempOutput!
        
        self.inStream?.delegate = self
        self.outStream?.delegate = self
        
        self.inStream?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        self.outStream?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        
        self.inStream?.open()
        self.outStream?.open()
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            p_handleConnectOpenCompletedStream(aStream: aStream)
        case Stream.Event.hasBytesAvailable:
            p_handleEventHasBytesAvailableStream(aStream: aStream)
        case Stream.Event.hasSpaceAvailable:
            p_handleEventHasSpaceAvailableStream(aStream: aStream)
        case Stream.Event.errorOccurred:
            p_handleEventErrorOccurredStream(aStream: aStream)
        case Stream.Event.endEncountered:
            p_handleEventEndEncounteredStream(aStream: aStream)
        default:
            print("Event type: EventNone")
        }
    }
    
    private func p_handleConnectOpenCompletedStream(aStream: Stream) {
        //print("handleConnectOpenCompleted")
        if aStream == outStream {
            print("connect open complete!")
        }
    }
    
    private func p_handleEventHasBytesAvailableStream(aStream: Stream) {
        //print("has bytes available")
        var buffer = [UInt8](repeating: 0, count: 2)
        if aStream == self.inStream {
            let len = self.inStream?.read(&buffer, maxLength: buffer.count)
            if len! > 0 {
                let output = String.init(bytes: buffer, encoding: String.Encoding.utf8)!
                if output != "" {
                    print("\(output)")
                }
            }
        }
    }
    
    private func p_handleEventHasSpaceAvailableStream(aStream: Stream) {
        //print("has space available")
        let myString = "Hi Simon, wie gehts dir?"
        let encodeDataArray = [UInt8](myString.utf8)
        self.outStream?.write(encodeDataArray, maxLength: encodeDataArray.count)
    }
    
    private func p_handleEventEndEncounteredStream(aStream: Stream) {
        print("handle eventEndEncountered")
    }
    
    private func p_handleEventErrorOccurredStream(aStream: Stream) {
        print("handle eventErrorOccurred")
    }
    
}
