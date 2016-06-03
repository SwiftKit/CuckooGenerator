//
//  FileHeaderHandler.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol FileHeaderHandler {
    static func getHeader(file: FileRepresentation) -> [String]
    
    static func getImports(testableFrameworks: [String]) -> [String]
}

extension FileHeaderHandler {
    
    static func minimumIndex(currentValue: Int, declarations: [Token]) -> Int {
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