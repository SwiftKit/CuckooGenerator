//
//  FileHeaderHandler_r1.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework
import SwiftXPC

struct FileHeaderHandler_r1: FileHeaderHandler {
    
    static func getHeader(testableFrameworks: [String])(file: FileRepresentation) -> [String] {
        let headerRange = 0..<minimumIndex(file.sourceFile.contents.characters.count, declarations: file.declarations)
        
        let generationInfo = "// MARK: - Mocks generated from file: \(file.sourceFile.path) at \(NSDate())\n"
        let imports = testableFrameworks.map { "@testable import \($0)" }
        
        return [generationInfo, "import Cuckoo"] + imports + [file.sourceFile.contents[headerRange]]
    }
}