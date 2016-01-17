//
//  Generator_r1.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

struct Generator_r1: Generator {

    static func generateWithIndentation(indentation: String)(token: Token) -> [String] {
        var output: [String] = []
        
        switch token {
        case .ProtocolDeclaration(let name, let accessibility, _, _, _, let children):
            guard accessibility != .Private else { return [] }
            
            output += "\(accessibility.sourceName) class \(mockWrapperClassName(name)): \(name), Cuckoo.Mock {"
            output += "    \(accessibility.sourceName) let manager: Cuckoo.MockManager<\(stubbingProxyName(name)), \(verificationProxyName(name))> = Cuckoo.MockManager()"
            output += ""
            output += "    private let observed: \(name)?"
            output += ""
            output += "    \(accessibility.sourceName) required init() {"
            output += "        observed = nil"
            output += "    }"
            output += ""
            output += "    \(accessibility.sourceName) required init(spyOn victim: \(name)) {"
            output += "        observed = victim"
            output += "    }"
            output += generateWithIndentation("    ")(tokens: children)
            output += ""
            output += generateStubbingWithIndentation("    ")(token: token)
            output += ""
            output += generateVerificationWithIndentation("    ")(token: token)
            output += "}"
        case .ProtocolMethod(let name, let accessibility, let returnSignature, _, _, let parameterTokens):
            guard accessibility != .Private else { return [] }
            let rawName = name.takeUntilStringOccurs("(") ?? ""
            
            let parameters = extractParameters(parameterLabels(name), tokens: parameterTokens)
            let fullyQualifiedName = fullyQualifiedMethodName(name, parameters: parameters, returnSignature: returnSignature)
            let parametersSignature = methodParametersSignature(parameters)
            
            var managerCall: String
            if returnSignature.containsString("throws") {
                managerCall = "try manager.callThrows(\"\(fullyQualifiedName)\""
            } else {
                managerCall = "manager.call(\"\(fullyQualifiedName)\""
            }
            if !parameters.isEmpty {
                managerCall += ", parameters: \(prepareEscapingParameters(parameters))"
            }
            managerCall += ", original: observed?.rawName)(\(methodForwardingCallParameters(parameters)))"
            
            output += ""
            output += "\(accessibility.sourceName) func \(rawName)(\(parametersSignature))\(returnSignature) {"
            output += "    return \(managerCall)"
            output += "}"
        case .MethodParameter, .Attribute: // Don't use default to make sure we handle future cases
            break
        }
        
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func generateStubbingWithIndentation(indentation: String = "")(tokens: [Token]) -> [String] {
        return tokens.flatMap(generateStubbingWithIndentation(indentation))
    }
    
    private static func generateStubbingWithIndentation(indentation: String = "")(token: Token) -> [String] {
        var output: [String] = []
        
        switch token {
        case .ProtocolDeclaration(let name, let accessibility, _, _, _, let children):
            guard accessibility != .Private else { return [] }
            
            output += "\(accessibility.sourceName) struct \(stubbingProxyName(name)): Cuckoo.StubbingProxy {"
            output += "    let handler: Cuckoo.StubbingHandler"
            output += ""
            output += "    \(accessibility.sourceName) init(handler: Cuckoo.StubbingHandler) {"
            output += "        self.handler = handler"
            output += "    }"
            output += generateStubbingWithIndentation(indentation)(tokens: children)
            output += ""
            output += "}"
        case .ProtocolMethod(let name, let accessibility, let returnSignature, _, _, let parameterTokens):
            guard accessibility != .Private else { return [] }
            let rawName = name.takeUntilStringOccurs("(") ?? ""
            
            let parameters = extractParameters(parameterLabels(name), tokens: parameterTokens)
            let fullyQualifiedName = fullyQualifiedMethodName(name, parameters: parameters, returnSignature: returnSignature)
            let parametersSignature = prepareMatchableParameterSignature(parameters)
            let throwing = returnSignature.containsString("throws")
            
            var returnType: String
            if throwing {
                returnType = "Cuckoo.ToBeStubbedThrowingFunction"
            } else {
                returnType = "Cuckoo.ToBeStubbedFunction"
            }
            returnType += "<"
            returnType += "(\(parametersTupleType(parameters)))"
            returnType += ", "
            returnType += extractReturnType(returnSignature) ?? "Void"
            returnType += ">"
            
            var stubCall: String
            if throwing {
                stubCall = "handler.stubThrowing(\"\(fullyQualifiedName)\""
            } else {
                stubCall = "handler.stub(\"\(fullyQualifiedName)\""
            }
            if !parameters.isEmpty {
                stubCall += ", parameterMatchers: matchers"
            }
            stubCall += ")"
            
            output += ""
            output += "@warn_unused_result"
            output += "\(accessibility.sourceName) func \(rawName)\(prepareMatchableGenerics(parameters))(\(parametersSignature)) -> \(returnType) {"
            output += "    \(prepareParameterMatchers(parameters))"
            output += "    return \(stubCall)"
            output += "}"
        case .MethodParameter, .Attribute: // Don't use default to make sure we handle future cases
            break
        }
        
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func generateVerificationWithIndentation(indentation: String = "")(tokens: [Token]) -> [String] {
        return tokens.flatMap(generateVerificationWithIndentation(indentation))
    }
    
    private static func generateVerificationWithIndentation(indentation: String = "")(token: Token) -> [String] {
        var output: [String] = []
        
        switch token {
        case .ProtocolDeclaration(let name, let accessibility, _, _, _, let children):
            guard accessibility != .Private else { return [] }
            
            output += "\(accessibility.sourceName) struct \(verificationProxyName(name)): Cuckoo.VerificationProxy {"
            output += "    let handler: Cuckoo.VerificationHandler"
            output += ""
            output += "    \(accessibility.sourceName) init(handler: Cuckoo.VerificationHandler) {"
            output += "        self.handler = handler"
            output += "    }"
            output += generateVerificationWithIndentation("    ")(tokens: children)
            output += ""
            output += "}"
        case .ProtocolMethod(let name, let accessibility, let returnSignature, _, _, let parameterTokens):
            guard accessibility != .Private else { return [] }
            let rawName = name.takeUntilStringOccurs("(") ?? ""
            
            let parameters = extractParameters(parameterLabels(name), tokens: parameterTokens)
            let fullyQualifiedName = fullyQualifiedMethodName(name, parameters: parameters, returnSignature: returnSignature)
            let parametersSignature = prepareMatchableParameterSignature(parameters)
            
            let returnType = "Cuckoo.__DoNotUse<" + (extractReturnType(returnSignature) ?? "Void") + ">"
            
            var verifyCall = "handler.verify(\"\(fullyQualifiedName)\""
            if !parameters.isEmpty {
                verifyCall += ", parameterMatchers: matchers"
            }
            verifyCall += ")"
            
            output += ""
            output += "\(accessibility.sourceName) func \(rawName)\(prepareMatchableGenerics(parameters))(\(parametersSignature)) -> \(returnType){"
            output += "    \(prepareParameterMatchers(parameters))"
            output += "    return \(verifyCall)"
            output += "}"
        case .MethodParameter, .Attribute: // Don't use default to make sure we handle future cases
            break
        }
        
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func mockClassName(originalName: String) -> String {
        return "Mock" + originalName
    }
    
    private static func mockWrapperClassName(originalName: String) -> String {
        return mockClassName(originalName) + "Wrapper"
    }
    
    private static func stubbingProxyName(originalName: String) -> String {
        return "__StubbingProxy_" + originalName
    }
    
    private static func verificationProxyName(originalName: String) -> String {
        return "__VerificationProxy_" + originalName
    }
    
    private static func fullyQualifiedMethodName(name: String, parameters: [Parameter], returnSignature: String) -> String {
        let parameterTypes = parameters.map { $0.type }
        let nameParts = name.componentsSeparatedByString(":")
        let lastNamePart = nameParts.last ?? ""
        
        return zip(nameParts.dropLast(), parameterTypes)
            .map { $0 + ":" + $1 }
            .joinWithSeparator(", ") + lastNamePart + returnSignature
    }
    
    private static func extractReturnType(returnSignature: String) -> String? {
        return returnSignature.trimmed.takeAfterStringOccurs("->")
    }
    
    private static func prepareEscapingParameters(parameters: [Parameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        let escapingParameters: [String] = parameters.map {
            if $0.attributes.contains(Attributes.noescape) || ($0.attributes.contains(Attributes.autoclosure) && !$0.attributes.contains(Attributes.escaping)) {
                return "Cuckoo.markerFunction()"
            } else {
                return $0.name
            }
        }
        
        return "(" + methodCall(parameters, andValues: escapingParameters) + ")"
    }
    
    private static func prepareMatchableGenerics(parameters: [Parameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let genericParameters = (1...parameters.count).map {
            "M\($0): Cuckoo.Matchable"
        }.joinWithSeparator(", ")
        
        let whereClause = parameters.enumerate().map {
            "M\($0 + 1).MatchedType == (\($1.type))"
        }.joinWithSeparator(", ")
        
        return "<\(genericParameters) where \(whereClause)>"
    }
    
    private static func prepareMatchableParameterSignature(parameters: [Parameter]) -> String {
        return parameters.enumerate().map {
            "\($1.labelAndNameAtPosition($0)): M\($0 + 1)"
        }.joinWithSeparator(", ")
    }
    
    private static func prepareParameterMatchers(parameters: [Parameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        let matchers: [String] = parameters.enumerate().map {
            "parameterMatcher(\($1.name).matcher) { \(parameters.count > 1 ? "$0.\($1.labelNameOrPositionAtPosition($0))" : "$0") }"
        }
        
        return "let matchers: [Cuckoo.AnyMatcher<(\(parametersTupleType(parameters)))>] = [\(matchers.joinWithSeparator(", "))]"
    }
}