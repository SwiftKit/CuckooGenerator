#!/usr/bin/swift -F Carthage/Build/Mac
//
//  main.swift
//  SwiftMockGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import SourceKittenFramework
import SwiftXPC
import Commandant

let testableFrameworks: [String] = ["UIKit"]
let source: String = [
    "import Foundation",
    "import UIKit",
    "protocol pA {",
    "func noParameter()",
    "func singleParameter(test: Bool)",
    "func multipleParameters(test: Bool, second: String)",
    "func multipleParametersWithNamed(test: Bool, secondName second: String)",
    "func multipleParametersWithUnnamed(test: Bool, _ second: String)",
    "func withOutput() throws -> Int",
    "}",
    "protocol pB {",
    "func warko()",
    "}"
].joinWithSeparator("\n")

let sourceFile = File(contents: source)

enum Kinds: String {
    case _Protocol = "source.lang.swift.decl.protocol"
    case InstanceMethod = "source.lang.swift.decl.function.method.instance"
    case MethodParameter = "source.lang.swift.decl.var.parameter"
}

enum Accessibility: String {
    case Public = "source.lang.swift.accessibility.public"
    case Internal = "source.lang.swift.accessibility.internal"
    case Private = "source.lang.swift.accessibility.private"
    
    var sourceName: String {
        switch self {
        case .Public:
            return "public"
        case .Internal:
            return "internal"
        case .Private:
            return "private"
        }
    }
}

enum Key: String {
    case Substructure = "key.substructure"
    case Kind = "key.kind"
    case Accessibility = "key.accessibility"
    case Name = "key.name"
    case TypeName = "key.typename"
    
    case Length = "key.length"
    case Offset = "key.offset"
    case NameLength = "key.namelength"
    case NameOffset = "key.nameoffset"
}

enum MockPart {
    case _Protocol(name: String, Accessibility, parts: [MockPart])
    case Method(name: String, Accessibility, restOfDeclaration: String, parameters: [MockPart])
    case MethodParameter(name: String, type: String)
}

var fileHeaderLength: Int = sourceFile.contents.characters.count

func parse(structures: [XPCRepresentable]) -> [MockPart] {
    return structures.map { $0 as! XPCDictionary }.flatMap(parse)
}

func parse(structure: XPCDictionary) -> [MockPart] {
    let name = structure[Key.Name.rawValue] as! String
    let accessibility = (structure[Key.Accessibility.rawValue] as? String).flatMap { Accessibility(rawValue: $0) }
    let out: MockPart
    let kind = structure[Key.Kind.rawValue] as! String
    
    let offset = Int(structure[Key.Offset.rawValue] as? Int64 ?? 0)
    let length = Int(structure[Key.Length.rawValue] as? Int64 ?? 0)
    let nameOffset = Int(structure[Key.NameOffset.rawValue] as? Int64 ?? 0)
    let nameLength = Int(structure[Key.NameLength.rawValue] as? Int64 ?? 0)
    
    if offset < fileHeaderLength {
        fileHeaderLength = offset
    }
    
    switch kind {
    case Kinds._Protocol.rawValue:
        let parts = parse(structure[Key.Substructure.rawValue] as! [XPCRepresentable])
        
        out = ._Protocol(name: name, accessibility!, parts: parts)
    case Kinds.InstanceMethod.rawValue:
        let parameters: [MockPart]
        if let rawParameters = structure[Key.Substructure.rawValue] as? [XPCRepresentable] where !rawParameters.isEmpty {
            parameters = parse(rawParameters)
        } else {
            parameters = []
        }
        
        let restOfDeclarationRange = sourceFile.contents.startIndex.advancedBy(nameOffset + nameLength)..<sourceFile.contents.startIndex.advancedBy(offset + length)
        let restOfDeclaration = sourceFile.contents[restOfDeclarationRange]
        print(restOfDeclaration)
        
        out = .Method(name: name, accessibility!, restOfDeclaration: restOfDeclaration, parameters: parameters)
    case Kinds.MethodParameter.rawValue:
        out = .MethodParameter(name: name, type: structure[Key.TypeName.rawValue] as! String)
    default:
        fatalError("Unknown kind \(kind)")
    }
    
    return [out]
}

let structure = Structure(file: sourceFile)
print(structure.description)

let topLevel = structure.dictionary[Key.Substructure.rawValue] as! [XPCRepresentable]

let parsed = parse(topLevel)


extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
    func takeUntilStringOccurs(occurence: String) -> String {
        return self.componentsSeparatedByString(occurence).first ?? ""
    }
}

func += <T>(inout lhs: [T], rhs: T) {
    lhs.append(rhs)
}

func parameterLabels(methodName: String) -> [String] {
    // Takes the string between `(` and `)`
    let parameters = methodName.componentsSeparatedByString("(").last?.characters.dropLast(1).map { "\($0)" }.joinWithSeparator("")
    
    return parameters!.componentsSeparatedByString(":")
}

func prependParametersWithLabels(methodName: String, parameters: [String: String]) -> [String] {
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

func prependParameterCallsWithLabels(methodName: String, parameters: [String: String]) -> [String] {
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

func fullyQualifiedMethodName(name: String, parameters: [String: String]) -> String {
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

/*
var allow_showLoadingScreenWithViewUIViewIndicatorViewMessageString: Bool = false
private(set) var timesCalled_showLoadingScreenWithViewUIViewIndicatorViewMessageString: Int = 0
override func showLoadingScreen(view: UIView?, indicatorView: JGProgressHUDIndicatorView?, message: String)
*/

func keyValueArrayToDict(keyValueArray: [String]) -> [String: String] {
    var output: [String: String] = [:]
    var key: String = ""
    for (index, keyValue) in keyValueArray.enumerate() {
        if index % 2 == 0 {
            key = keyValue
        } else {
            output[key] = keyValue
        }
    }
    return output
}

func generate(parts: [MockPart], indentation: String = "") -> [String] {
    return parts.flatMap { generate($0, indentation: indentation) }
}

func generate(part: MockPart, indentation: String = "") -> [String] {
    var output: [String] = []
    
    switch part {
    case ._Protocol(let name, let accessibility, let parts):
        guard accessibility != .Private else { return [] }
        
        output += "\(accessibility.sourceName) class Mock_\(name): \(name) {"
        output += ""
        output += "    let wrapped: \(name)"
        output += ""
        output += "    \(accessibility.sourceName) init(wrapped: \(name)) {"
        output += "        self.wrapped = wrapped"
        output += "    }"
        output += generate(parts, indentation: indentation + "    ")
        output += "}"

    case .Method(let name, let accessibility, let restOfDeclaration, let parameters):
        guard accessibility != .Private else { return [] }
        let rawName = name.takeUntilStringOccurs("(")
        
        let unlabeledParameters = keyValueArrayToDict(generate(parameters))
        let fullyQualifiedName = rawName + fullyQualifiedMethodName(name, parameters: unlabeledParameters)
        let parametersString = prependParametersWithLabels(name, parameters: unlabeledParameters).joinWithSeparator(", ")
        let shouldTry: String
        if restOfDeclaration.containsString("throws") {
            shouldTry = "try "
        } else {
            shouldTry = ""
        }
        
        output += ""
        output += "\(accessibility.sourceName) var allow_\(fullyQualifiedName): Bool = false"
        output += "\(accessibility.sourceName) private(set) var timesCalled_\(fullyQualifiedName): Int = 0"
        output += "\(accessibility.sourceName) func \(rawName)(\(parametersString))\(restOfDeclaration) {"
        output += "    assert(allow_\(rawName), \"This method was not allowed to be called!\")"
        output += "    timesCalled_\(rawName) += 1"
        output += "    return \(shouldTry)wrapped.\(rawName)(\(prependParameterCallsWithLabels(name, parameters: unlabeledParameters).joinWithSeparator(", ")))"
        output += "}"
    case .MethodParameter(let name, let type):
        output += "\(name)"
        output += "\(type)"
    }
    
    return output.map { "\(indentation)\($0)" }
}

print("")
print("")

let fileHeaderRange = sourceFile.contents.startIndex..<sourceFile.contents.startIndex.advancedBy(fileHeaderLength)
var fileHeader = sourceFile.contents[fileHeaderRange]
for testableFramework in testableFrameworks {
    if let importRange = fileHeader.rangeOfString("import \(testableFramework)") {
        fileHeader.replaceRange(importRange, with: "@testable import \(testableFramework)")
    }
}

let generatedMock = fileHeader + "\n" + generate(parsed).joinWithSeparator("\n")

print(generatedMock)

print("")
print("")

//print(Structure(file: File(contents: generatedMock)))

