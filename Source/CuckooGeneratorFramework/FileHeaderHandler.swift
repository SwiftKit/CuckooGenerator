//
//  FileHeaderHandler.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct FileHeaderHandler {
    
    public static func getHeader(file: FileRepresentation) -> [String] {
        let generationInfo = "// MARK: - Mocks generated from file: \(file.sourceFile.path ?? "unknown") at \(NSDate())\n"
        let headerEnd = minimumIndex(file.sourceFile.contents.unicodeScalars.count, declarations: file.declarations)
        let utf8Header = file.sourceFile.contents.utf8.prefix(headerEnd)
        let header = String(utf8Header) ?? ""
        return [generationInfo, header]
    }
    
    public static func getImports(testableFrameworks: [String]) -> [String] {
        return ["import Cuckoo"] + testableFrameworks.map { "@testable import \($0)" }
    }
    
    private static func minimumIndex(currentValue: Int, declarations: [Token]) -> Int {
        return declarations.reduce(currentValue) { minimum, declaration in
            switch declaration {
            case let containerToken as ContainerToken:
                return containerToken.range.startIndex
            case let method as Method:
                return method.range.startIndex
            default:
                return minimum
            }
        }
    }
}
