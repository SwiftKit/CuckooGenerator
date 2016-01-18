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
        let generationInfo = "// MARK: - Mocks generated from file: \(file.sourceFile.path ?? "unknown") at \(NSDate())\n"
        let imports = testableFrameworks.map { "@testable import \($0)" }
        
        let headerEnd = minimumIndex(file.sourceFile.contents.unicodeScalars.count, declarations: file.declarations)
        let utf8Header = file.sourceFile.contents.utf8.prefix(headerEnd)
        let header = String(utf8Header) ?? ""
        
        return [generationInfo, header, "import Cuckoo"] + imports
    }
}