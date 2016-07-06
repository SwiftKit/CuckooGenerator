//
//  Generator.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct Generator {
    
    private let declarations: [Token]
    private let code = CodeBuilder()
    
    public init(file: FileRepresentation) {
        declarations = file.declarations
    }
    
    public func generate() -> String {
        code.clear()
        generate(declarations)
        return code.code
    }
    
    private func generate(tokens: [Token]) {
        tokens.forEach { generate($0) }
    }
    
    private func generate(token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateMockingClass(containerToken)
        case let property as InstanceVariable:
            generateMockingProperty(property)
        case let method as Method:
            generateMockingMethod(method)
        default:
            break
        }
    }
    
    private func generateMockingClass(token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        code += ""
        code += "\(accessibility)class \(mockClassName(token.name)): \(token.name), Cuckoo.Mock {"
        code.nest {
            code += "\(accessibility)typealias Stubbing = \(stubbingProxyName(token.name))"
            code += "\(accessibility)typealias Verification = \(verificationProxyName(token.name))"
            code += "\(accessibility)let manager = Cuckoo.MockManager()"
            code += ""
            code += "private var observed: \(token.name)?"
            code += ""
            code += "\(accessibility)required\(token.implementation ? " override" : "") init() {"
            code += "}"
            code += ""
            code += "\(accessibility)required init(spyOn victim: \(token.name)) {"
            code.nest("observed = victim")
            code += "}"
            token.children.forEach { generate($0) }
            code += ""
            generateStubbing(token)
            code += ""
            generateVerification(token)
        }
        code += "}"
    }
    
    private func generateMockingProperty(token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        code += ""
        code += "\(accessibility)\(token.overriding ? "override " : "")var \(token.name): \(token.type) {"
        code.nest {
            code += "get {"
            code.nest("return manager.getter(\"\(token.name)\", original: observed.map { o in return { () -> \(token.type) in o.\(token.name) } })")
            code += "}"
            if token.readOnly == false {
                code += "set {"
                code.nest("manager.setter(\"\(token.name)\", value: newValue, original: observed != nil ? { self.observed?.\(token.name) = $0 } : nil)")
                code += "}"
            }
        }
        code += "}"
    }
    
    private func generateMockingMethod(token: Method) {
        guard token.accessibility != .Private else { return }
        
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
        
        code += ""
        code += "\(accessibility)\(isOverriding ? "override " : "")\(isInitializer ? "" : "func " )\(rawName)(\(parametersSignature))\(token.returnSignature) {"
        code.nest("return \(managerCall)")
        code += "}"
    }
    
    private func generateStubbing(token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateStubbingClass(containerToken)
        case let property as InstanceVariable:
            generateStubbingProperty(property)
        case let method as Method:
            generateStubbingMethod(method)
        default:
            break
        }
    }
    
    private func generateStubbingClass(token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        code += "\(accessibility)struct \(stubbingProxyName(token.name)): Cuckoo.StubbingProxy {"
        code.nest {
            code += "let manager: Cuckoo.MockManager"
            code += ""
            code += "\(accessibility)init(manager: Cuckoo.MockManager) {"
            code.nest("self.manager = manager")
            code += "}"
            token.children.forEach { generateStubbing($0) }
        }
        code += "}"
    }
    
    private func generateStubbingProperty(token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.ToBeStubbedReadOnlyProperty" : "Cuckoo.ToBeStubbedProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(token.type)> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\")")
        code += "}"
    }
    
    private func generateStubbingMethod(token: Method) {
        guard token.accessibility != .Private else { return }
        
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
        
        code += ""
        code += "@warn_unused_result"
        code += "\(accessibility)func \(rawName)\(prepareMatchableGenerics(token.parameters))(\(parametersSignature)) -> \(stubbingMethodReturnType) {"
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[]"
        } else {
            code.nest("\(prepareParameterMatchers(token.parameters))")
            matchers = "matchers"
        }
        code.nest("return \(stubFunction)(stub: manager.createStub(\"\(fullyQualifiedName)\", parameterMatchers: \(matchers)))")
        code += "}"
    }
    
    private func generateVerification(token: Token) {
        switch token {
        case let containerToken as ContainerToken:
            generateVerificationClass(containerToken)
        case let property as InstanceVariable:
            generateVerificationProperty(property)
        case let method as Method:
            generateVerificationMethod(method)
        default:
            break
        }
    }
    
    private func generateVerificationClass(token: ContainerToken) {
        guard token.accessibility != .Private else { return }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        
        code += "\(accessibility)struct \(verificationProxyName(token.name)): Cuckoo.VerificationProxy {"
        code.nest {
            code += "let manager: Cuckoo.MockManager"
            code += "let callMatcher: Cuckoo.CallMatcher"
            code += "let sourceLocation: Cuckoo.SourceLocation"
            code += ""
            code += "\(accessibility)init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {"
            code.nest {
                code += "self.manager = manager"
                code += "self.callMatcher = callMatcher"
                code += "self.sourceLocation = sourceLocation"
            }
            code += "}"
            token.children.forEach { generateVerification($0) }
        }
        code += "}"
    }
    
    private func generateVerificationProperty(token: InstanceVariable) {
        guard token.accessibility != .Private else { return }
        
        let propertyType = token.readOnly ? "Cuckoo.VerifyReadOnlyProperty" : "Cuckoo.VerifyProperty"
        
        code += ""
        code += "var \(token.name): \(propertyType)<\(token.type)> {"
        code.nest("return \(propertyType)(manager: manager, name: \"\(token.name)\", callMatcher: callMatcher, sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func generateVerificationMethod(token: Method) {
        guard token.accessibility != .Private else { return }
        
        let accessibility = getAccessibilitySourceName(token.accessibility)
        let rawName = token.name.takeUntilStringOccurs("(") ?? ""
        let fullyQualifiedName = fullyQualifiedMethodName(token.name, parameters: token.parameters, returnSignature: token.returnSignature)
        let parametersSignature = prepareMatchableParameterSignature(token.parameters)
        let returnType = "Cuckoo.__DoNotUse<" + (extractReturnType(token.returnSignature) ?? "Void") + ">"
        
        code += ""
        code += "\(accessibility)func \(rawName)\(prepareMatchableGenerics(token.parameters))(\(parametersSignature)) -> \(returnType){"
        let matchers: String
        if token.parameters.isEmpty {
            matchers = "[] as [Cuckoo.ParameterMatcher<Void>]"
        } else {
            code.nest("\(prepareParameterMatchers(token.parameters))")
            matchers = "matchers"
        }
        code.nest("return manager.verify(\"\(fullyQualifiedName)\", callMatcher: callMatcher, parameterMatchers: \(matchers), sourceLocation: sourceLocation)")
        code += "}"
    }
    
    private func mockClassName(originalName: String) -> String {
        return "Mock" + originalName
    }
    
    private func stubbingProxyName(originalName: String) -> String {
        return "__StubbingProxy_" + originalName
    }
    
    private func verificationProxyName(originalName: String) -> String {
        return "__VerificationProxy_" + originalName
    }
    
    private func fullyQualifiedMethodName(name: String, parameters: [MethodParameter], returnSignature: String) -> String {
        let parameterTypes = parameters.map { $0.type }
        let nameParts = name.componentsSeparatedByString(":")
        let lastNamePart = nameParts.last ?? ""
        
        return zip(nameParts.dropLast(), parameterTypes)
            .map { $0 + ": " + $1 }
            .joinWithSeparator(", ") + lastNamePart + returnSignature
    }
    
    private func extractReturnType(returnSignature: String) -> String? {
        return returnSignature.takeAfterStringOccurs("->")?.trimmed
    }
    
    private func prepareEscapingParameters(parameters: [MethodParameter]) -> String {
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
    
    private func prepareMatchableGenerics(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let genericParameters = (1...parameters.count).map { "M\($0): Cuckoo.Matchable" }.joinWithSeparator(", ")
        let whereClause = parameters.enumerate().map { "M\($0 + 1).MatchedType == (\($1.type))" }.joinWithSeparator(", ")
        return "<\(genericParameters) where \(whereClause)>"
    }
    
    private func prepareMatchableParameterSignature(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        return parameters.enumerate().map { "\($1.labelAndNameAtPosition($0)): M\($0 + 1)" }.joinWithSeparator(", ")
    }
    
    private func prepareParameterMatchers(parameters: [MethodParameter]) -> String {
        guard parameters.isEmpty == false else { return "" }
        
        let matchers = parameters.enumerate().map {
            "parameterMatcher(\($1.name).matcher) { \(parameters.count > 1 ? "$0.\($1.labelNameOrPositionAtPosition($0))" : "$0") }"
        }.joinWithSeparator(", ")
        return "let matchers: [Cuckoo.ParameterMatcher<(\(parametersTupleType(parameters)))>] = [\(matchers)]"
    }
    
    private func getAccessibilitySourceName(accessibility: Accessibility) -> String {
        if accessibility == .Internal {
            return ""
        } else {
            return accessibility.sourceName + " "
        }
    }
    
    private func methodForwardingCallParameters(parameters: [MethodParameter], ignoreSingleLabel: Bool = false) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 && ignoreSingleLabel {
            return firstParameter.name
        } else {
            return methodCall(parameters, andValues: parameters.map { $0.name })
        }
    }
    
    private func methodCall(parameters: [MethodParameter], andValues values: [String]) -> String {
        let labels = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
        return zip(labels, values).map { $0.isEmpty ? $1 : "\($0): \($1)" }.joinWithSeparator(", ")
    }
    
    private func methodParametersSignature(parameters: [MethodParameter]) -> String {
        return parameters.enumerate().map {
            "\($1.attributes.sourceRepresentation)\($1.labelAndNameAtPosition($0)): \($1.type)"
            }.joinWithSeparator(", ")
    }
    
    private func parametersTupleType(parameters: [MethodParameter]) -> String {
        if let firstParameter = parameters.first where parameters.count == 1 {
            return firstParameter.type
        } else {
            let labelsOrNames = parameters.enumerate().map { $1.labelOrNameAtPosition($0) }
            return zip(labelsOrNames, parameters).map { $0.isEmpty ? $1.type : "\($0): \($1.type)" }.joinWithSeparator(", ")
        }
    }
}
