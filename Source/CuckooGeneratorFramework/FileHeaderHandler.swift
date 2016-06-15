//
//  FileHeaderHandler.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import FileKit

public struct FileHeaderHandler {
    
    public static func getHeader(file: FileRepresentation, withTimestamp timestamp: Bool) -> [String] {
        let path: String
        if let absolutePath = file.sourceFile.path {
            path = getRelativePath(absolutePath)
        } else {
            path = "unknown"
        }
        let generationInfo = "// MARK: - Mocks generated from file: \(path)" + (timestamp ? " at \(NSDate())\n" : "")
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
            let declarationMinimum: Int
            switch declaration {
            case let containerToken as ContainerToken:
                declarationMinimum = containerToken.range.startIndex
            case let method as Method:
                declarationMinimum = method.range.startIndex
            default:
                declarationMinimum = minimum
            }
            return min(declarationMinimum, minimum)
        }
    }
    
    private static func getRelativePath(absolutePath: String) -> String {
        let path = Path(absolutePath)
        let base = path.commonAncestor(Path.Current)
        let components = path.components.suffixFrom(base.components.endIndex)
        let result = components.map { $0.rawValue }.joinWithSeparator(Path.separator)
        let difference = Path.Current.components.endIndex - base.components.endIndex
        return (0..<difference).reduce(result) { acc, _ in "../" + acc }
    }
}
