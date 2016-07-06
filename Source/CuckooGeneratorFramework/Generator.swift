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
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        var output: [String] = []
        output += ""
        output += "\(accessibility)class \(mockClassName(token.name)): \(token.name), Cuckoo.Mock {"
        output += "    \(accessibility)typealias Stubbing = \(stubbingProxyName(token.name))"
        output += "    \(accessibility)typealias Verification = \(verificationProxyName(token.name))"
        output += "    \(accessibility)let manager = Cuckoo.MockManager()"
        output += ""
        output += "    private var observed: \(token.name)?"
        output += ""
        output += "    \(accessibility)required\(token.implementation ? " override" : "") init() {"
        output += "    }"
        output += ""
        output += "    \(accessibility)required init(spyOn victim: \(token.name)) {"
        output += "        observed = victim"
        output += "    }"
        output += generateWithIndentation("    ", tokens: token.children)
        output += ""
        output += generateStubbingWithIndentation("    ", token: token)
        output += ""
        output += generateVerificationWithIndentation("    ", token: token)
        output += "}"
        return output
    }
    
    private static func generateMockingProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        var output: [String] = []
        output += ""
        output += "\(accessibility)\(token.overriding ? "override " : "")var \(token.name): \(token.type) {"
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
        guard token.accessibility != .Private else { return [] }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        let isOverriding = token is ClassMethod
        let rawName = token.name.takeUntilStringOccurs("(") ?? ""
        let isInitializer = rawName == "init"
        let fullyQualifiedName = fullyQualifiedMethodName(token.name, parameters: token.parameters, returnSignature: token.returnSignature)
        let parametersSignature = methodParametersSignature(token.parameters)
        
        var managerCall: String
        let tryIfThrowing: String
        if token.returnSignature.trimmed.hasPrefix("throws") {
            managerCall = "try manager.callThrows(\"\(fullyQualifiedName)\""
            tryIfThrowing = "try "
        } else {
            managerCall = "manager.call(\"\(fullyQualifiedName)\""
            tryIfThrowing = ""
        }
        managerCall += ", parameters: \(prepareEscapingParameters(token.parameters))"
        managerCall += ", original: observed.map { o in return { (\(parametersSignature))\(token.returnSignature) in \(tryIfThrowing)o.\(rawName)(\(methodForwardingCallParameters(token.parameters))) } })"
        
        var output: [String] = []
        output += ""
        output += "\(accessibility)\(isOverriding ? "override " : "")\(isInitializer ? "" : "func " )\(rawName)(\(parametersSignature))\(token.returnSignature) {"
        output += "    return \(managerCall)"
        output += "}"
        return output
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
        guard token.accessibility != .Private else { return [] }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)

        var output: [String] = []
        output += "\(accessibility)struct \(stubbingProxyName(token.name)): Cuckoo.StubbingProxy {"
        output += "    let manager: Cuckoo.MockManager"
        output += ""
        output += "    \(accessibility)init(manager: Cuckoo.MockManager) {"
        output += "        self.manager = manager"
        output += "    }"
        output += token.children.flatMap { generateStubbingWithIndentation("    ", token: $0) }
        output += "}"
        return output
    }
    
    private static func generateStubbingProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        let propertyType = token.readOnly ? "Cuckoo.ToBeStubbedReadOnlyProperty" : "Cuckoo.ToBeStubbedProperty"
        
        var output: [String] = []
        output += ""
        output += "var \(token.name): \(propertyType)<\(token.type)> {"
        output += "    return \(propertyType)(manager: manager, name: \"\(token.name)\")"
        output += "}"
        return output
    }
    
    private static func generateStubbingMethod(token: Method) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        let rawName = token.name.takeUntilStringOccurs("(") ?? ""
        let fullyQualifiedName = fullyQualifiedMethodName(token.name, parameters: token.parameters, returnSignature: token.returnSignature)
        let parametersSignature = prepareMatchableParameterSignature(token.parameters)
        let throwing = token.returnSignature.containsString("throws")
        let returnType = extractReturnType(token.returnSignature) ?? "Void"
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
        stubbingMethodReturnType += "(\(parametersTupleType(token.parameters)))"
        if returnType != "Void" {
            stubbingMethodReturnType += ", "
            stubbingMethodReturnType += returnType
        }
        stubbingMethodReturnType += ">"
        
        
        var output: [String] = []
        output += ""
        output += "@warn_unused_result"
        output += "\(accessibility)func \(rawName)\(prepareMatchableGenerics(token.parameters))(\(parametersSignature)) -> \(stubbingMethodReturnType) {"
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[]"
        } else {
            output += "    \(prepareParameterMatchers(token.parameters))"
            matchers = "matchers"
        }
        output += "    return \(stubFunction)(stub: manager.createStub(\"\(fullyQualifiedName)\", parameterMatchers: \(matchers)))"
        output += "}"
        return output
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
        guard token.accessibility != .Private else { return [] }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        var output: [String] = []
        output += "\(accessibility)struct \(verificationProxyName(token.name)): Cuckoo.VerificationProxy {"
        output += "    let manager: Cuckoo.MockManager"
        output += "    let callMatcher: Cuckoo.CallMatcher"
        output += "    let sourceLocation: Cuckoo.SourceLocation"
        output += ""
        output += "    \(accessibility)init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {"
        output += "        self.manager = manager"
        output += "        self.callMatcher = callMatcher"
        output += "        self.sourceLocation = sourceLocation"
        output += "    }"
        output += token.children.flatMap { generateVerificationWithIndentation("    ", token: $0) }
        output += "}"
        return output
    }
    
    private static func generateVerificationProperty(token: InstanceVariable) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        let propertyType = token.readOnly ? "Cuckoo.VerifyReadOnlyProperty" : "Cuckoo.VerifyProperty"
        
        var output: [String] = []
        output += ""
        output += "var \(token.name): \(propertyType)<\(token.type)> {"
        output += "    return \(propertyType)(manager: manager, name: \"\(token.name)\", callMatcher: callMatcher, sourceLocation: sourceLocation)"
        output += "}"
        return output
    }
    
    private static func generateVerificationMethod(token: Method) -> [String] {
        guard token.accessibility != .Private else { return [] }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        let rawName = token.name.takeUntilStringOccurs("(") ?? ""
        let fullyQualifiedName = fullyQualifiedMethodName(token.name, parameters: token.parameters, returnSignature: token.returnSignature)
        let parametersSignature = prepareMatchableParameterSignature(token.parameters)
        let returnType = "Cuckoo.__DoNotUse<" + (extractReturnType(token.returnSignature) ?? "Void") + ">"
        
        var output: [String] = []
        output += ""
        output += "\(accessibility)func \(rawName)\(prepareMatchableGenerics(token.parameters))(\(parametersSignature)) -> \(returnType){"
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[] as [Cuckoo.ParameterMatcher<Void>]"
        } else {
            output += "    \(prepareParameterMatchers(token.parameters))"
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
        
        let genericParameters = (1...parameters.count).map { "M\($0): Cuckoo.Matchable" }.joinWithSeparator(", ")
        let whereClause = parameters.enumerate().map { "M\($0 + 1).MatchedType == (\($1.type))" }.joinWithSeparator(", ")
        return "<\(genericParameters) where \(whereClause)>"
    }
    
    private static func prepareMatchableParameterSignature(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        return parameters.enumerate().map { "\($1.labelAndNameAtPosition($0)): M\($0 + 1)" }.joinWithSeparator(", ")
    }
    
    private static func prepareParameterMatchers(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let matchers = parameters.enumerate().map {
            "parameterMatcher(\($1.name).matcher) { \(parameters.count > 1 ? "$0.\($1.labelNameOrPositionAtPosition($0))" : "$0") }"
        }.joinWithSeparator(", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(parametersTupleType(parameters)))>] = [\(matchers)]"
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
        } else {
            return methodCall(parameters, andValues: parameters.map { $0.name })
        }
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
        } else {
            let labelsOrNames = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
            return zip(labelsOrNames, parameters).map { $0.isEmpty ? $1.type : "\($0): \($1.type)" }.joinWithSeparator(", ")
        }
    }
}
