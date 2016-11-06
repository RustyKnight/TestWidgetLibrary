//
//  ServerManager.swift
//  TestWidgetClient
//
//  Created by Shane Whitehead on 5/11/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class ServerManager: NSObject {
	
	public static let shared = ServerManager()
	
	let socket: GCDAsyncSocket
	let strongDelegate: ServerDelegate = ServerDelegate()
	
	public var isConnected: Bool {
		return socket.isConnected
	}
	
	override init() {
		socket = GCDAsyncSocket()
		super.init()
		socket.delegateQueue = DispatchQueue.main
		socket.delegate = strongDelegate
	}
	
	public func connect() throws {
		guard !isConnected else {
			return
		}
		try socket.connect(toHost: "192.168.0.10", onPort: 5000)
	}
	
	public func disconnect() {
		guard isConnected else {
			return
		}
		socket.disconnect()
	}
	
	public func sendRequest(text: String) {
		guard isConnected else {
			return
		}
		
		let length: UInt = UInt(text.characters.count)
		let data = length.data
		
		socket.write(data, withTimeout: -1, tag: 1)
	}
}

class ServerDelegate: NSObject, GCDAsyncSocketDelegate {
	func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
		log(debug: "\(host):\(port)")
	}
	
	func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
		log(debug: "\(err)")
	}
	
	func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
	}
}
