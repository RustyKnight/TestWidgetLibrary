//
//  LogUtilities.swift
//  TestWidgetClient
//
//  Created by Shane Whitehead on 5/11/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

func log(_ prefix: String, message: String, file: String = #file, function: String = #function, line: Int = #line) {
	let parts = file.components(separatedBy: "/")
	guard let last = parts.last else {
		print("\(prefix)[\(file).\(function):\(line)] \(message)")
		return
	}
	print("\(prefix)[\(last)][\(function):\(line)] \(message)")
}

func log(debug: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("🐞", message: debug, file: file, function: function, line: line)
}

func log(info: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("💡", message: info, file: file, function: function, line: line)
}

func log(warn: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("⚠️", message: warn, file: file, function: function, line: line)
}

func log(error: String, file: String = #file, function: String = #function, line: Int = #line) {
	log("☠️", message: error, file: file, function: function, line: line)
}

func log(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
	log("☠️", message: "\(error)", file: file, function: function, line: line)
}
