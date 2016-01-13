//
//  Generator.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//


struct Generator {
    
    static func generate(file: FileRepresentation) -> [String] {
        return  file.declarations.flatMap(generate())
    }
    
    static func generate(indentation: String = "")(_ parts: [Declaration]) -> [String] {
        return parts.flatMap(generate(indentation))
    }
    
    static func generate(indentation: String = "")(_ part: Declaration) -> [String] {
        var output: [String] = []
        
        switch part {
        case .ProtocolDeclaration(let name, let accessibility, _, _, _, let children):
            guard accessibility != .Private else { return [] }
            
            output += "\(accessibility.sourceName) class Mock_\(name): \(name) {"
            output += ""
            output += "    let wrapped: \(name)"
            output += ""
            output += "    \(accessibility.sourceName) init(wrapped: \(name)) {"
            output += "        self.wrapped = wrapped"
            output += "    }"
            output += generate(indentation + "    ")(children)
            output += "}"
            
        case .ProtocolMethod(let name, let accessibility, let returnSignature, _, _, let parameters):
            guard accessibility != .Private else { return [] }
            let rawName = name.takeUntilStringOccurs("(")
            
            let unlabeledParameters = keyValueArrayToDict(generate()(parameters))
            let fullyQualifiedName = rawName + fullyQualifiedMethodName(name, parameters: unlabeledParameters)
            let parametersString = prependParametersWithLabels(name, parameters: unlabeledParameters).joinWithSeparator(", ")
            let shouldTry: String
            if returnSignature.containsString("throws") {
                shouldTry = "try "
            } else {
                shouldTry = ""
            }
            
            output += ""
            output += "\(accessibility.sourceName) var allow_\(fullyQualifiedName): Bool = false"
            output += "\(accessibility.sourceName) private(set) var timesCalled_\(fullyQualifiedName): Int = 0"
            output += "\(accessibility.sourceName) func \(rawName)(\(parametersString))\(returnSignature) {"
            output += "    assert(allow_\(rawName), \"This method was not allowed to be called!\")"
            output += "    timesCalled_\(rawName) += 1"
            output += "    return \(shouldTry)wrapped.\(rawName)(\(prependParameterCallsWithLabels(name, parameters: unlabeledParameters).joinWithSeparator(", ")))"
            output += "}"
        case .MethodParameter(let name, let type, _, _):
            output += "\(name)"
            output += "\(type)"
        }
        
        return output.map { "\(indentation)\($0)" }
    }
    
    
    private static func parameterLabels(methodName: String) -> [String] {
        // Takes the string between `(` and `)`
        let parameters = methodName.componentsSeparatedByString("(").last?.characters.dropLast(1).map { "\($0)" }.joinWithSeparator("")
        
        return parameters!.componentsSeparatedByString(":")
    }
    
    private static func prependParametersWithLabels(methodName: String, parameters: [String: String]) -> [String] {
        let labels = parameterLabels(methodName)
        
        return parameters.enumerate().map { index, parameter in
            let name = parameter.0
            let type = parameter.1
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
    
    private static func prependParameterCallsWithLabels(methodName: String, parameters: [String: String]) -> [String] {
        let labels = parameterLabels(methodName)
        
        return parameters.enumerate().map { index, parameter in
            let name = parameter.0
            let label = labels[index]
            let labelOrName: String
            if index == 0 || label == "_" {
                labelOrName = ""
            } else if label != "_" {
                labelOrName = "\(label): "
            } else {
                labelOrName = "\(name): "
            }
            
            return "\(labelOrName)\(name)"
        }
    }
    
    private static func fullyQualifiedMethodName(name: String, parameters: [String: String]) -> String {
        let labels = parameterLabels(name)
        
        return parameters.enumerate().map { index, parameter in
            let name = parameter.0
            let type = parameter.1
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
}