//
//  MockeryGeneratorFrameworkTests.swift
//  MockeryGeneratorFrameworkTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import XCTest
@testable import CuckooGeneratorFramework

class CuckooGeneratorFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGeneratingMocks() {
        let options = GenerateMocksCommand.Options.create(.v0_4_1)(output: "\(PROJECT_DIR)/Tests/output.swift")(testableFrameworks: "CuckooGenerator")(files: ["\(PROJECT_DIR)/Tests/TestedClass.swift"
, "\(PROJECT_DIR)/Tests/TestedProtocol.swift"])
        let generator = GenerateMocksCommand()
        generator.run(options)
    }


}
