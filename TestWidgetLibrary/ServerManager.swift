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
	
	enum Tag: Int {
		case headerTag = 100
		case bodyTag = 101
	}
	
	public var isConnected: Bool {
		return socket.isConnected
	}
	
	override init() {
		socket = GCDAsyncSocket()
		super.init()
		socket.delegateQueue = DispatchQueue.main
		socket.delegate = strongDelegate
	}
	
	public func connect(to host: String, onPort: Int) throws {
		guard !isConnected else {
			return
		}
		try socket.connect(toHost: host, onPort: onPort)
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
		
		log(debug: "Write length of \(length)")
		socket.write(data, withTimeout: -1, tag: Tag.headerTag.rawValue)
		log(debug: "Write text - \(text)")
		socket.write(text.data, withTimeout: -1, tag: Tag.bodyTag.rawValue)
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
