//
//  GeneratorHelpers.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

typealias Parameter = (name: String, type: String)

public protocol Generator {
    
    static func generate(file: FileRepresentation) -> [String]
    
    static func generate(parts: [Declaration]) -> [String]
    
    static func generate(part: Declaration) -> [String]

    static func generateWithIndentation(indentation: String)(_ parts: [Declaration]) -> [String]
    
    static func generateWithIndentation(indentation: String)(_ part: Declaration) -> [String]
}

extension Generator {
    
    public static func generate(file: FileRepresentation) -> [String] {
        return file.declarations.flatMap(generate)
    }
    
    public static func generate(parts: [Declaration]) -> [String] {
        return parts.flatMap(generate)
    }
    
    public static func generate(part: Declaration) -> [String] {
        return generateWithIndentation("")(part)
    }
    
    public static func generateWithIndentation(indentation: String)(_ parts: [Declaration]) -> [String] {
        return parts.flatMap(generateWithIndentation(indentation))
    }
    
    internal static func parameterLabels(methodName: String) -> [String] {
        // Takes the string between `(` and `)`
        let parameters = methodName.componentsSeparatedByString("(").last?.characters.dropLast(1).map { "\($0)" }.joinWithSeparator("")
            
        return parameters!.componentsSeparatedByString(":")
    }
        
    internal static func prependParametersWithLabels(methodName: String, parameters: [Parameter]) -> [String] {
        let labels = parameterLabels(methodName)
        
        return parameters.enumerate().map { index, parameter in
            let name = parameter.name
            let type = parameter.type
            var label = labels[index]
            if index == 0 && label == "_" {
                label = ""
            } else if index > 0 && label == name {
                label = ""
            }
            
            let labelAndName = label.isEmpty ? name : "\(label) \(name)"
            
            return "\(labelAndName): \(type)"
        }
    }
    
    internal static func prependParameterCallsWithLabels(methodName: String, parameters: [Parameter]) -> [String] {
        let labels = parameterLabels(methodName)
        
        return parameters.enumerate().map { index, parameter in
            let name = parameter.name
            let label = labels[index]
            let labelOrName: String
            if index == 0 && label == "_" {
                labelOrName = ""
            } else if label != "_" {
                labelOrName = "\(label): "
            } else {
                labelOrName = "\(name): "
            }
            
            return "\(labelOrName)\(name)"
        }
    }
    
    internal static func fullyQualifiedMethodName(name: String, parameters: [Parameter]) -> String {
        let labels = parameterLabels(name)
        
        return parameters.enumerate().map { index, parameter in
            let name = parameter.name
            let type = safeTypeName(parameter.type)
            let label = labels[index]
            let labelOrName: String
            if index == 0 || label == "_" {
                labelOrName = ""
            } else if label != "_" {
                labelOrName = label.uppercaseFirst
            } else {
                labelOrName = name.uppercaseFirst
            }
            return "\(labelOrName)\(type)"
            }.joinWithSeparator("")
    }
    
    internal static func safeTypeName(typeName: String) -> String {
        let charactersToRemove = NSCharacterSet.alphanumericCharacterSet().invertedSet
        return typeName.componentsSeparatedByCharactersInSet(charactersToRemove).joinWithSeparator("")
    }
    
}