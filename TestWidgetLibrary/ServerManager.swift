//
//  ServerManager.swift
//  TestWidgetClient
//
//  Created by Shane Whitehead on 5/11/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import SwiftyJSON

protocol ServerDelegate {
	func serverDidSendResponse(_ json: JSON)
}

public class ServerManager: NSObject {
	
	public static let shared = ServerManager()
	
	let socket: GCDAsyncSocket
	
	var delegate: ServerDelegate?
	
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
		socket.delegate = self
	}
	
	public func connect(to host: String, onPort: UInt16) throws {
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
	
	public func sendRequest(json: JSON) {
		guard let text = json.rawString(.utf8, options: []) else {
			log(error: "Bad encoding?!")
			return
		}
		sendRequest(text: text)
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

extension ServerManager: GCDAsyncSocketDelegate {
	
	public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
		log(debug: "\(host):\(port)")
		readHeader(from: sock)
	}
	
	public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
		log(debug: "\(err)")
	}
	
	public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
		log(debug: "Read data with tag of \(tag)")
		guard let tagValue = Tag(rawValue: tag) else {
			log(error: "Not a valid tag")
			return
		}
		switch tagValue {
		case .bodyTag:
			log(info: "Did read text \(text)")
			let json = JSON(data)
			delegate?.serverDidSendResponse(json)
		case .headerTag:
			guard let length = UInt(data: data) else {
				log(error: "Failed to decode length from data ... \(data)")
				readHeader(from: sock)
				return
			}
			log(info: "Did read length of \(length)")
			log(info: "Read body...")
			readBody(from: sock, toLength: length)
		}
	}
	
	func readHeader(from socket: GCDAsyncSocket) {
		log(debug: "Reading \(UInt(MemoryLayout<UInt>.size)) bytes")
		socket.readData(toLength: UInt(MemoryLayout<UInt>.size),
		                withTimeout: -1,
		                tag: Tag.headerTag)
	}
	
	func readBody(from socket: GCDAsyncSocket, toLength: UInt) {
		log(debug: "Reading \(toLength) bytes")
		socket.readData(toLength: toLength,
		                withTimeout: -1,
		                tag: Tag.bodyTag)
	}
}

extension GCDAsyncSocket {
	func readData<T: RawRepresentable>(toLength length: UInt, withTimeout timeout: TimeInterval, tag: T) where T.RawValue == Int {
		readData(toLength: length, withTimeout: timeout, tag: tag.rawValue)
	}
}
