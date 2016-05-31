//
//  GeneratorHelpers.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public protocol Generator {

    static func generate(file: FileRepresentation) -> [String]
    
    static func generate(tokens: [Token]) -> [String]
    
    static func generate(token: Token) -> [String]

    static func generateWithIndentation(indentation: String, tokens: [Token]) -> [String]
    
    static func generateWithIndentation(indentation: String, token: Token) -> [String]
}

// MARK: - Overloads
extension Generator {
    
    public static func generate(file: FileRepresentation) -> [String] {
        return file.declarations.flatMap(generate)
    }
    
    public static func generate(tokens: [Token]) -> [String] {
        return tokens.flatMap(generate)
    }
    
    public static func generate(token: Token) -> [String] {
        return generateWithIndentation("", token: token)
    }
    
    public static func generateWithIndentation(indentation: String, tokens: [Token]) -> [String] {
      return tokens.flatMap({ t in generateWithIndentation(indentation, token: t) })
    }

}

// MARK: - Parameter helpers
extension Generator {
    
    static func methodForwardingCallParameters(parameters: [MethodParameter], ignoreSingleLabel: Bool = false) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 && ignoreSingleLabel {
            return firstParameter.name
        }
        return methodCall(parameters, andValues: parameters.map { $0.name })
    }
    
    static func methodCall(parameters: [MethodParameter], andValues values: [String]) -> String {
        let labels = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        return zip(labels, values).map { $0.isEmpty ? $1 : "\($0): \($1)" }.joinWithSeparator(", ")
    }
    
    static func methodParametersSignature(parameters: [MethodParameter]) -> String {
        return parameters.enumerate().map {
            "\($1.attributes.sourceRepresentation)\($1.labelAndNameAtPosition($0)): \($1.type)"
        }.joinWithSeparator(", ")
    }
    
    static func parametersTupleType(parameters: [MethodParameter]) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 {
            return firstParameter.type
        }
        
        let labelsOrNames = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        
        return zip(labelsOrNames, parameters).map { $0.isEmpty ? $1.type : "\($0): \($1.type)" }.joinWithSeparator(", ")
    }
}