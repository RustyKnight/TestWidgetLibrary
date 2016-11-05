//
//  LogUtilities.swift
//  TestWidgetClient
//
//  Created by Shane Whitehead on 5/11/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

public func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
	let parts = file.components(separatedBy: "/")
	guard let last = parts.last else {
		print("[\(file).\(function):\(line)] \(message)")
		return
	}
	print("[\(last)][\(function):\(line)] \(message)")
}

public func log(debug: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("🐞 \(debug)", file: file, function: function, line: line)
}

public func log(info: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("💡 \(info)", file: file, function: function, line: line)
}

public func log(warn: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("⚠️ \(warn)", file: file, function: function, line: line)
}

public func log(error: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("☠️ \(error)", file: file, function: function, line: line)
}

public func log(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
	log("☠️ \(error)", file: file, function: function, line: line)
}
