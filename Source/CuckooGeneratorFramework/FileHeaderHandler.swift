//
//  FileHeaderHandler.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol FileHeaderHandler {
    static func getHeader(testableFrameworks: [String])(file: FileRepresentation) -> [String]
}

extension FileHeaderHandler {
    
    static func minimumIndex(currentValue: Int, declarations: [Token]) -> Int {
        return declarations.reduce(currentValue) { minimum, declaration in
            switch declaration {
            case .ProtocolDeclaration(_, _, let range, _, _, let children):
                return minimumIndex(min(minimum, range.startIndex), declarations: children)
            case .ProtocolMethod(_, _, _, let range, _, let parameters):
                return minimumIndex(min(minimum, range.startIndex), declarations: parameters)
            case .MethodParameter(_, _, let range, _, _):
                return min(minimum, range.startIndex)
            case .Attribute(_):
                return minimum
            }
        }
    }
}