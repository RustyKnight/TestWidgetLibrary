//
//  DataExtenstion.swift
//  TestWidgetLibrary
//
//  Created by Shane Whitehead on 6/11/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

protocol DataConvertible {
	init?(data: Data)
	var data: Data { get }
}

extension DataConvertible {
	
	init?(data: Data) {
		guard data.count == MemoryLayout<Self>.size else { return nil }
		self = data.withUnsafeBytes { $0.pointee }
	}
	
	var data: Data {
		var value = self
		return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
	}
}

extension Int : DataConvertible { }
extension Float : DataConvertible { }
extension Double : DataConvertible { }
extension UInt : DataConvertible { }

extension String: DataConvertible {
	init?(data: Data) {
		self.init(data: data, encoding: .utf8)
	}
	var data: Data {
		// Note: a conversion to UTF-8 cannot fail.
		return self.data(using: .utf8)!
	}
}
