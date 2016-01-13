//
//  FileHeaderHandler.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework
import SwiftXPC

public struct FileHeaderHandler {

    public static func getHeader(testableFrameworks: [String])(file: FileRepresentation) -> String {
        let headerRange = 0..<minimumIndex(file.sourceFile.contents.characters.count, declarations: file.declarations)

        let generationInfo = "// MARK: - Mocks generated from file: \(file.sourceFile.path) at \(NSDate())\n"
        let imports = testableFrameworks.map { "@testable import \($0)" }.joinWithSeparator("\n")

        return generationInfo + imports + "\n" + file.sourceFile.contents[headerRange]
    }
    
    private static func minimumIndex(currentValue: Int, declarations: [Declaration]) -> Int {
        return declarations.reduce(currentValue) { minimum, declaration in
            switch declaration {
            case .ProtocolDeclaration(_, _, let range, _, _, let children):
                return minimumIndex(min(minimum, range.startIndex), declarations: children)
            case .ProtocolMethod(_, _, _, let range, _, let parameters):
                return minimumIndex(min(minimum, range.startIndex), declarations: parameters)
            case .MethodParameter(_, _, let range, _):
                return min(minimum, range.startIndex)
            }
        }
    }
    
}