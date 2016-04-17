//
//  GeneratorHelpers.swift
//  MockeryGenerator
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
    
    internal static func parameterLabels(methodName: String) -> [String?] {
        // Takes the string between `(` and `)`
        let parameters = methodName.componentsSeparatedByString("(").last?.characters.dropLast(1).map { "\($0)" }.joinWithSeparator("")
        
        return parameters?.componentsSeparatedByString(":").map { $0 != "_" ? $0 : nil } ?? []
    }
    
    internal static func methodForwardingCallParameters(parameters: [MethodParameter], ignoreSingleLabel: Bool = false) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 && ignoreSingleLabel {
            return firstParameter.name
        }
        return methodCall(parameters, andValues: parameters.map { $0.name })
    }
    
    internal static func methodCall(parameters: [MethodParameter], andValues values: [String]) -> String {
        let labels = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        return zip(labels, values).map { $0.isEmpty ? $1 : "\($0): \($1)" }.joinWithSeparator(", ")
    }
    
    internal static func methodParametersSignature(parameters: [MethodParameter]) -> String {
        return parameters.enumerate().map {
            "\($1.attributes.sourceRepresentation)\($1.labelAndNameAtPosition($0)): \($1.type)"
        }.joinWithSeparator(", ")
    }
    
    internal static func parametersTupleType(parameters: [MethodParameter]) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 {
            return firstParameter.type
        }
        
        let labelsOrNames = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        
        return zip(labelsOrNames, parameters).map { $0.isEmpty ? $1.type : "\($0): \($1.type)" }.joinWithSeparator(", ")
    }
    
    //internal static func name
    
    internal static func safeTypeName(typeName: String) -> String {
        let charactersToRemove = NSCharacterSet.alphanumericCharacterSet().invertedSet
        return typeName.componentsSeparatedByCharactersInSet(charactersToRemove).joinWithSeparator("")
    }
}