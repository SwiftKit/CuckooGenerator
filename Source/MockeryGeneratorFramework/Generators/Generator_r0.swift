//
//  Generator.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

struct Generator_r0: Generator {
    
    static func generateWithIndentation(indentation: String)(token: Token) -> [String] {
        var output: [String] = []
        
        switch token {
        case .ProtocolDeclaration(let name, let accessibility, _, _, _, let children):
            guard accessibility != .Private else { return [] }
            
            output += "\(accessibility.sourceName) class Mock_\(name): \(name) {"
            output += ""
            output += "    let wrapped: \(name)"
            output += ""
            output += "    \(accessibility.sourceName) init(wrapped: \(name)) {"
            output += "        self.wrapped = wrapped"
            output += "    }"
            output += generateWithIndentation(indentation + "    ")(tokens: children)
            output += "}"
            
        case .ProtocolMethod(let name, let accessibility, let returnSignature, _, _, let parameters):
            guard accessibility != .Private else { return [] }
            let rawName = name.takeUntilStringOccurs("(")
            
            let unlabeledParameters: [Parameter] = keyValueArrayToTupleArray(generate(parameters)).map { $0 }
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
            output += "    assert(allow_\(fullyQualifiedName), \"This method was not allowed to be called!\")"
            output += "    timesCalled_\(fullyQualifiedName) += 1"
            output += "    return \(shouldTry)wrapped.\(rawName)(\(prependParameterCallsWithLabels(name, parameters: unlabeledParameters).joinWithSeparator(", ")))"
            output += "}"
        case .MethodParameter(let name, let type, _, _):
            output += "\(name)"
            output += "\(type)"
        }
        
        return output.map { "\(indentation)\($0)" }
    }
}