//
//  VerboseLoggerTests.swift
//  VariantsCoreTests
//
//  Created by Abdoelrhman Eaita on 17/09/2021.
//

import XCTest

@testable import VariantsCore

class VerboseLoggerTests: XCTestCase {
    
    func testCreatingVerboseWithTimeStampLog() {
        let sut = MockVerboseLogger(verbose: true, showTimestamp: true)
       
        let prefix = ""
        let item = "test"
        let indentationLevel = 1
        let color = ShellColor.blue
        let logLevel = LogLevel.verbose
        let date = Date()
        
        let results = sut.createLog(LogData(item: item, indentationLevel: indentationLevel, color: color, logLevel: logLevel, date: date))

        let indentation = String(repeating: "   ", count: indentationLevel)
        let expected = logLevel.rawValue
            .appending("[\(date.logTimestamp())]: ▸ ")
            .appending(indentation)
            .appending("\(color.bold())\(prefix)")
            .appending("\(color.rawValue)\(item)\(ShellColor.neutral.rawValue)")
        
        XCTAssertEqual(results, expected)
    }
    
    func testCreatingVerboseLogWithNoneVerboseSUT() {
        let sut = MockVerboseLogger(verbose: false, showTimestamp: true)
        
        let item = "test"
        let indentationLevel = 1
        let color = ShellColor.blue
        let logLevel = LogLevel.verbose
        let date = Date()
        
        let results = sut.createLog(LogData(item: item, indentationLevel: indentationLevel, color: color, logLevel: logLevel, date: date))
        XCTAssertEqual(results, "")
    }
}
