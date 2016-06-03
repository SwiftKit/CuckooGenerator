//
//  FileHeaderHandler_r1.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework

struct FileHeaderHandler_r1: FileHeaderHandler {
    
    static func getHeader(file: FileRepresentation) -> [String] {
        let generationInfo = "// MARK: - Mocks generated from file: \(file.sourceFile.path ?? "unknown") at \(NSDate())\n"
        let headerEnd = minimumIndex(file.sourceFile.contents.unicodeScalars.count, declarations: file.declarations)
        let utf8Header = file.sourceFile.contents.utf8.prefix(headerEnd)
        let header = String(utf8Header) ?? ""
        return [generationInfo, header]
    }
    
    static func getImports(testableFrameworks: [String]) -> [String] {
        return ["import Cuckoo"] + testableFrameworks.map { "@testable import \($0)" }
    }
}