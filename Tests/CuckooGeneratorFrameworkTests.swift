//
//  CuckooGeneratorFrameworkTests.swift
//  CuckooGeneratorFrameworkTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import XCTest
@testable import CuckooGeneratorFramework

private let res = "\(PROJECT_DIR)/Tests/res/"
private let source = res + "source/"

class CuckooGeneratorFrameworkTests: XCTestCase {
    
    func testGeneratingMocks() {
        let options = GenerateMocksCommand.Options.create(.v0_4_1)(output: res + "actual.swift")(testableFrameworks: "CuckooGenerator")(files: [source + "TestedClass.swift", source + "TestedProtocol.swift"])
        let generator = GenerateMocksCommand()
        generator.run(options)
        
        let expected = removeMark(readFile(res + "expected.swift"))
        let actual = removeMark(readFile(res + "actual.swift"))
    
        XCTAssertEqual(expected, actual)
        XCTAssertTrue(expected == actual, "File content is not equal.")
    }

    
    private func readFile(path: String) -> String {
        return try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
    }
    
    private func removeMark(text: String) -> String {
        var result = text
        while (true) {
            if let startIndex = result.rangeOfString("// MARK:")?.startIndex {
                let endIndex = result.rangeOfString("\n", range: startIndex..<result.endIndex)?.endIndex ?? text.endIndex
                result.removeRange(startIndex..<endIndex)
            } else {
                return result
            }
        }
    }
}
