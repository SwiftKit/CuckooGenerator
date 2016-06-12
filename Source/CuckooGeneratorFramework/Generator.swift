//
//  Generator.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct Generator {
    
    public static func generate(file: FileRepresentation) -> [String] {
        return generateWithIndentation("", tokens: file.declarations)
    }
    
    private static func generateWithIndentation(indentation: String, tokens: [Token]) -> [String] {
        return tokens.flatMap { generateWithIndentation(indentation, token: $0) }
    }
    
    private static func generateWithIndentation(indentation: String, token: Token) -> [String] {
        var output: [String] = []
        switch token {
        case let containerToken as ContainerToken:
            output += generateMockingClass(containerToken)
        case let property as InstanceVariable:
            output += generateMockingProperty(property)
        case let method as Method:
            output += generateMockingMethod(method)
        default:
            break
        }
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func generateMockingClass(token: ContainerToken) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let implementation = token.implementation
        let children = token.children
        
        guard accessibility != .Private else { return [] }
        
        var output: [String] = []
        output += ""
        output += "\(getAccessibilitySourceName(accessibility))class \(mockClassName(name)): \(name), Cuckoo.Mock {"
        output += "    \(getAccessibilitySourceName(accessibility))let manager: Cuckoo.MockManager<\(stubbingProxyName(name)), \(verificationProxyName(name))> = Cuckoo.MockManager()"
        output += ""
        output += "    private var observed: \(name)?"
        output += ""
        output += "    \(getAccessibilitySourceName(accessibility))required\(implementation ? " override" : "") init() {"
        output += "    }"
        output += ""
        output += "    \(getAccessibilitySourceName(accessibility))required init(spyOn victim: \(name)) {"
        output += "        observed = victim"
        output += "    }"
        output += generateWithIndentation("    ", tokens: children)
        output += ""
        output += generateStubbingWithIndentation("    ", token: token)
        output += ""
        output += generateVerificationWithIndentation("    ", token: token)
        output += "}"
        return output
    }
    
    private static func generateMockingProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        var output: [String] = []
        output += ""
        output += "\(getAccessibilitySourceName(token.accessibility))\(token.overriding ? "override " : "")var \(token.name): \(token.type) {"
        output += "    get {"
        output += "        return manager.getter(\"\(token.name)\", original: observed.map { o in return { () -> \(token.type) in o.\(token.name) } })()"
        output += "    }"
        
        if token.readOnly == false {
            output += "    set {"
            output += "        manager.setter(\"\(token.name)\", value: newValue, original: { self.observed?.\(token.name) = $0 })(newValue)"
            output += "    }"
        }
        
        output += "}"
        
        return output
    }
    
    private static func generateMockingMethod(token: Method) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let returnSignature = token.returnSignature
        let isOverriding = token is ClassMethod
        let parameters = token.parameters
        
        guard accessibility != .Private else { return [] }
        var output: [String] = []
        let rawName = name.takeUntilStringOccurs("(") ?? ""
        let isInitializer = rawName == "init"
        
        let fullyQualifiedName = fullyQualifiedMethodName(name, parameters: parameters, returnSignature: returnSignature)
        let parametersSignature = methodParametersSignature(parameters)
        
        var managerCall: String
        let tryIfThrowing: String
        if returnSignature.containsString("throws") {
            managerCall = "try manager.callThrows(\"\(fullyQualifiedName)\""
            tryIfThrowing = "try "
        } else {
            managerCall = "manager.call(\"\(fullyQualifiedName)\""
            tryIfThrowing = ""
        }
        
        managerCall += ", parameters: \(prepareEscapingParametersForParameters(parameters))"
        
        managerCall += ", original: observed.map { o in return { (\(parametersSignature))\(returnSignature) in \(tryIfThrowing)o.\(rawName)(\(methodForwardingCallParameters(parameters))) } })"
        managerCall += prepareEscapingParametersForMethodCall(parameters)
        
        output += ""
        output += "\(getAccessibilitySourceName(accessibility))\(isOverriding ? "override " : "")\(isInitializer ? "" : "func " )\(rawName)(\(parametersSignature))\(returnSignature) {"
        output += "    return \(managerCall)"
        output += "}"
        return output
    }
    
    
    private static func generateStubbingWithIndentation(indentation: String = "", tokens: [Token]) -> [String] {
        return tokens.flatMap { t in generateStubbingWithIndentation(indentation, token: t) }
    }
    
    private static func generateStubbingWithIndentation(indentation: String = "", token: Token) -> [String] {
        var output: [String] = []
        
        switch token {
        case let containerToken as ContainerToken:
            output += generateStubbingClass(containerToken)
            
        case let property as InstanceVariable:
            output += generateStubbingProperty(property)
            
        case let method as Method:
            output += generateStubbingMethod(method)
            
        default:
            break
        }
        
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func generateStubbingClass(token: ContainerToken) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let children = token.children
        
        guard accessibility != .Private else { return [] }
        var output: [String] = []
        
        output += "\(getAccessibilitySourceName(accessibility))struct \(stubbingProxyName(name)): Cuckoo.StubbingProxy {"
        output += "    let handler: Cuckoo.StubbingHandler"
        output += ""
        output += "    \(getAccessibilitySourceName(accessibility))init(handler: Cuckoo.StubbingHandler) {"
        output += "        self.handler = handler"
        output += "    }"
        output += generateStubbingWithIndentation("    ", tokens: children)
        output += "}"
        
        return output
    }
    
    private static func generateStubbingProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        var output: [String] = []
        
        let propertyType = token.readOnly ? "ToBeStubbedReadOnlyProperty" : "ToBeStubbedProperty"
        let stubbingFunction = token.readOnly ? "stubReadOnlyProperty" : "stubProperty"
        
        output += ""
        output += "var \(token.name): \(propertyType)<\(token.type)> {"
        output += "    return handler.\(stubbingFunction)(\"\(token.name)\")"
        output += "}"
        
        return output
    }
    
    private static func generateStubbingMethod(token: Method) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let returnSignature = token.returnSignature
        let parameters = token.parameters
        
        guard accessibility != .Private else { return [] }
        var output: [String] = []
        let rawName = name.takeUntilStringOccurs("(") ?? ""
        
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
        output += "\(getAccessibilitySourceName(accessibility))func \(rawName)\(prepareMatchableGenerics(parameters))(\(parametersSignature)) -> \(returnType) {"
        if !parameters.isEmpty {
            output += "    \(prepareParameterMatchers(parameters))"
        }
        output += "    return \(stubCall)"
        output += "}"
        
        return output
    }
    
    private static func generateVerificationWithIndentation(indentation: String = "", tokens: [Token]) -> [String] {
        return tokens.flatMap { t in generateVerificationWithIndentation(indentation, token: t) }
    }
    
    private static func generateVerificationWithIndentation(indentation: String = "", token: Token) -> [String] {
        var output: [String] = []
        
        switch token {
        case let containerToken as ContainerToken:
            output += generateVerificationClass(containerToken)
            
        case let property as InstanceVariable:
            output += generateVerificationProperty(property)
            
        case let method as Method:
            output += generateVerificationMethod(method)
            
        default:
            break
        }
        
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func generateVerificationClass(token: ContainerToken) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let children = token.children
        
        guard accessibility != .Private else { return [] }
        var output: [String] = []
        output += "\(getAccessibilitySourceName(accessibility))struct \(verificationProxyName(name)): Cuckoo.VerificationProxy {"
        output += "    let handler: Cuckoo.VerificationHandler"
        output += ""
        output += "    \(getAccessibilitySourceName(accessibility))init(handler: Cuckoo.VerificationHandler) {"
        output += "        self.handler = handler"
        output += "    }"
        output += generateVerificationWithIndentation("    ", tokens: children)
        output += "}"
        return output
    }
    
    private static func generateVerificationProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        var output: [String] = []
        
        let propertyType = token.readOnly ? "VerifyReadOnlyProperty" : "VerifyProperty"
        let verificationFunction = token.readOnly ? "verifyReadOnlyProperty" : "verifyProperty"
        
        output += ""
        output += "var \(token.name): \(propertyType)<\(token.type)> {"
        output += "    return handler.\(verificationFunction)(\"\(token.name)\")"
        output += "}"
        
        return output
    }
    
    private static func generateVerificationMethod(token: Method) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let returnSignature = token.returnSignature
        let parameters = token.parameters
        
        guard accessibility != .Private else { return [] }
        var output: [String] = []
        let rawName = name.takeUntilStringOccurs("(") ?? ""
        
        let fullyQualifiedName = fullyQualifiedMethodName(name, parameters: parameters, returnSignature: returnSignature)
        let parametersSignature = prepareMatchableParameterSignature(parameters)
        
        let returnType = "Cuckoo.__DoNotUse<" + (extractReturnType(returnSignature) ?? "Void") + ">"
        
        var verifyCall = "handler.verify(\"\(fullyQualifiedName)\""
        if !parameters.isEmpty {
            verifyCall += ", parameterMatchers: matchers"
        }
        verifyCall += ")"
        
        output += ""
        output += "\(getAccessibilitySourceName(accessibility))func \(rawName)\(prepareMatchableGenerics(parameters))(\(parametersSignature)) -> \(returnType){"
        if !parameters.isEmpty {
            output += "    \(prepareParameterMatchers(parameters))"
        }
        output += "    return \(verifyCall)"
        output += "}"
        return output
    }
    
    private static func mockClassName(originalName: String) -> String {
        return "Mock" + originalName
    }
    
    private static func stubbingProxyName(originalName: String) -> String {
        return "__StubbingProxy_" + originalName
    }
    
    private static func verificationProxyName(originalName: String) -> String {
        return "__VerificationProxy_" + originalName
    }
    
    private static func fullyQualifiedMethodName(name: String, parameters: [MethodParameter], returnSignature: String) -> String {
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
    
    private static func prepareEscapingParametersForParameters(parameters: [MethodParameter]) -> String {
        let result = prepareEscapingParameters(parameters) {
            $0.contains(Attributes.noescape) || ($0.contains(Attributes.autoclosure) && !$0.contains(Attributes.escaping))
        }
        return result == "()" ? "Void()" : result
    }
    
    private static func prepareEscapingParametersForMethodCall(parameters: [MethodParameter]) -> String {
        return prepareEscapingParameters(parameters) {
            $0.contains(Attributes.noescape)
        }
    }
    
    private static func prepareEscapingParameters(parameters: [MethodParameter], condition: Attributes -> Bool) -> String {
        guard parameters.isEmpty == false else { return "()" }
        let escapingParameters: [String] = parameters.map {
            if condition($0.attributes) {
                return "Cuckoo.markerFunction()"
            } else {
                return $0.name
            }
        }
        
        if let firstParameter = escapingParameters.first where escapingParameters.count == 1 {
            return "(" + firstParameter + ")"
        }
        
        return "(" + methodCall(parameters, andValues: escapingParameters) + ")"
    }
    
    private static func prepareMatchableGenerics(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let genericParameters = (1...parameters.count)
            .map { "M\($0): Cuckoo.Matchable" }
            .joinWithSeparator(", ")
        
        let whereClause = parameters.enumerate()
            .map { "M\($0 + 1).MatchedType == (\($1.type))" }
            .joinWithSeparator(", ")
        
        return "<\(genericParameters) where \(whereClause)>"
    }
    
    private static func prepareMatchableParameterSignature(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        return parameters.enumerate()
            .map { "\($1.labelAndNameAtPosition($0)): M\($0 + 1)" }
            .joinWithSeparator(", ")
    }
    
    private static func prepareParameterMatchers(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        let matchers: [String] = parameters.enumerate().map {
            "parameterMatcher(\($1.name).matcher) { \(parameters.count > 1 ? "$0.\($1.labelNameOrPositionAtPosition($0))" : "$0") }"
        }
        
        return "let matchers: [Cuckoo.AnyMatcher<(\(parametersTupleType(parameters)))>] = [\(matchers.joinWithSeparator(", "))]"
    }
    
    private static func getAccessibilitySourceName(accessibility: Accessibility) -> String {
        if accessibility == .Internal {
            return ""
        } else {
            return accessibility.sourceName + " "
        }
    }
    
    private static func methodForwardingCallParameters(parameters: [MethodParameter], ignoreSingleLabel: Bool = false) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 && ignoreSingleLabel {
            return firstParameter.name
        }
        return methodCall(parameters, andValues: parameters.map { $0.name })
    }
    
    private static func methodCall(parameters: [MethodParameter], andValues values: [String]) -> String {
        let labels = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        return zip(labels, values).map { $0.isEmpty ? $1 : "\($0): \($1)" }.joinWithSeparator(", ")
    }
    
    private static func methodParametersSignature(parameters: [MethodParameter]) -> String {
        return parameters.enumerate().map {
            "\($1.attributes.sourceRepresentation)\($1.labelAndNameAtPosition($0)): \($1.type)"
            }.joinWithSeparator(", ")
    }
    
    private static func parametersTupleType(parameters: [MethodParameter]) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 {
            return firstParameter.type
        }
        
        let labelsOrNames = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        
        return zip(labelsOrNames, parameters).map { $0.isEmpty ? $1.type : "\($0): \($1.type)" }.joinWithSeparator(", ")
    }
}
