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
        guard token.accessibility != .Private else { return [] }
        
        let name = token.name
        let accessibility = getAccessibilitySourceName(token.accessibility)
        let implementation = token.implementation
        let children = token.children
        
        var output: [String] = []
        output += ""
        output += "\(accessibility)class \(mockClassName(name)): \(name), Cuckoo.Mock {"
        output += "    \(accessibility)typealias Stubbing = \(stubbingProxyName(name))"
        output += "    \(accessibility)typealias Verification = \(verificationProxyName(name))"
        output += "    \(accessibility)let manager = Cuckoo.MockManager()"
        output += ""
        output += "    private var observed: \(name)?"
        output += ""
        output += "    \(accessibility)required\(implementation ? " override" : "") init() {"
        output += "    }"
        output += ""
        output += "    \(accessibility)required init(spyOn victim: \(name)) {"
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
        output += "        return manager.getter(\"\(token.name)\", original: observed.map { o in return { () -> \(token.type) in o.\(token.name) } })"
        output += "    }"

        if token.readOnly == false {
            output += "    set {"
            output += "        manager.setter(\"\(token.name)\", value: newValue, original: observed != nil ? { self.observed?.\(token.name) = $0 } : nil)"
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
        
        managerCall += ", parameters: \(prepareEscapingParameters(parameters))"
        
        managerCall += ", original: observed.map { o in return { (\(parametersSignature))\(returnSignature) in \(tryIfThrowing)o.\(rawName)(\(methodForwardingCallParameters(parameters))) } })"
        
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
        output += "    let manager: Cuckoo.MockManager"
        output += ""
        output += "    \(getAccessibilitySourceName(accessibility))init(manager: Cuckoo.MockManager) {"
        output += "        self.manager = manager"
        output += "    }"
        output += generateStubbingWithIndentation("    ", tokens: children)
        output += "}"
        
        return output
    }
    
    private static func generateStubbingProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        var output: [String] = []
        
        let propertyType = token.readOnly ? "Cuckoo.ToBeStubbedReadOnlyProperty" : "Cuckoo.ToBeStubbedProperty"
        
        output += ""
        output += "var \(token.name): \(propertyType)<\(token.type)> {"
        output += "    return \(propertyType)(manager: manager, name: \"\(token.name)\")"
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
        
        let returnType = extractReturnType(returnSignature) ?? "Void"
        let stubFunction: String
        if throwing {
            if returnType == "Void" {
                stubFunction = "Cuckoo.StubNoReturnThrowingFunction"
            } else {
                stubFunction = "Cuckoo.StubThrowingFunction"
            }
        } else {
            if returnType == "Void" {
                stubFunction = "Cuckoo.StubNoReturnFunction"
            } else {
                stubFunction = "Cuckoo.StubFunction"
            }
        }
        var stubbingMethodReturnType = stubFunction
        stubbingMethodReturnType += "<"
        stubbingMethodReturnType += "(\(parametersTupleType(parameters)))"
        if returnType != "Void" {
            stubbingMethodReturnType += ", "
            stubbingMethodReturnType += returnType
        }
        stubbingMethodReturnType += ">"
        
        output += ""
        output += "@warn_unused_result"
        output += "\(getAccessibilitySourceName(accessibility))func \(rawName)\(prepareMatchableGenerics(parameters))(\(parametersSignature)) -> \(stubbingMethodReturnType) {"
        let matchers: String
        if parameters.isEmpty {
            matchers = "[]"
        } else {
            output += "    \(prepareParameterMatchers(parameters))"
            matchers = "matchers"
        }
        output += "    return \(stubFunction)(stub: manager.createStub(\"\(fullyQualifiedName)\", parameterMatchers: \(matchers)))"
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
        output += "    let manager: Cuckoo.MockManager"
        output += "    let callMatcher: Cuckoo.CallMatcher"
        output += "    let sourceLocation: Cuckoo.SourceLocation"
        output += ""
        output += "    \(getAccessibilitySourceName(accessibility))init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {"
        output += "        self.manager = manager"
        output += "        self.callMatcher = callMatcher"
        output += "        self.sourceLocation = sourceLocation"
        output += "    }"
        output += generateVerificationWithIndentation("    ", tokens: children)
        output += "}"
        return output
    }
    
    private static func generateVerificationProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        var output: [String] = []
        
        let propertyType = token.readOnly ? "Cuckoo.VerifyReadOnlyProperty" : "Cuckoo.VerifyProperty"
        
        output += ""
        output += "var \(token.name): \(propertyType)<\(token.type)> {"
        output += "    return \(propertyType)(manager: manager, name: \"\(token.name)\", callMatcher: callMatcher, sourceLocation: sourceLocation)"
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
        
        output += ""
        output += "\(getAccessibilitySourceName(accessibility))func \(rawName)\(prepareMatchableGenerics(parameters))(\(parametersSignature)) -> \(returnType){"
        let matchers: String
        if parameters.isEmpty {
            matchers = "[] as [Cuckoo.ParameterMatcher<Void>]"
        } else {
            output += "    \(prepareParameterMatchers(parameters))"
            matchers = "matchers"
        }
        output += "    return manager.verify(\"\(fullyQualifiedName)\", callMatcher: callMatcher, parameterMatchers: \(matchers), sourceLocation: sourceLocation)"
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
        return returnSignature.takeAfterStringOccurs("->")?.trimmed
    }
    
    private static func prepareEscapingParameters(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "Void()" }
        let escapingParameters: [String] = parameters.map {
            if $0.attributes.contains(Attributes.noescape) || ($0.attributes.contains(Attributes.autoclosure) && !$0.attributes.contains(Attributes.escaping)) {
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
        
        return "let matchers: [Cuckoo.ParameterMatcher<(\(parametersTupleType(parameters)))>] = [\(matchers.joinWithSeparator(", "))]"
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
