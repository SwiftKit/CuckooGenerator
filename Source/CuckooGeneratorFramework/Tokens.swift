//
//  SourceDefinitions.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import SourceKittenFramework
import SwiftXPC

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
    
    case BodyLength = "key.bodylength"
    case BodyOffset = "key.bodyoffset"
    
    case Attributes = "key.attributes"
    case Attribute = "key.attribute"
}

enum Kinds: String {
    case ProtocolDeclaration = "source.lang.swift.decl.protocol"
    case InstanceMethod = "source.lang.swift.decl.function.method.instance"
    case MethodParameter = "source.lang.swift.decl.var.parameter"
    case ClassDeclaration = "source.lang.swift.decl.class"

    case NoescapeAttribute = "source.decl.attribute.noescape"
    case AutoclosureAttribute = "source.decl.attribute.autoclosure"
}

public enum Accessibility: String {
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

public struct Attributes: OptionSetType {
    static let none = Attributes(rawValue: 0)
    static let noescape = Attributes(rawValue: 1 << 0)
    static let autoclosure = Attributes(rawValue: 1 << 1)
    static let escaping = Attributes(rawValue: 1 << 2)
    
    static let escapingAutoclosure: Attributes = [autoclosure, escaping]
    
    public let rawValue : Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    var sourceRepresentation: String {
        return !self.isEmpty ? sourceRepresentations.joinWithSeparator(" ") + " " : ""
    }
    
    var sourceRepresentations: [String] {
        var mutableCopy = self
        var representation: [String] = []
        
        if let _ = mutableCopy.remove(Attributes.escapingAutoclosure) {
            representation += "@autoclosure(escaping)"
        }
        
        if let _ = mutableCopy.remove(Attributes.autoclosure) {
            representation += "@autoclosure"
        }
        
        if let _ = mutableCopy.remove(Attributes.noescape) {
            representation += "@noescape"
        }
        
        if !mutableCopy.isEmpty {
            fputs("Unknown attributes: \(mutableCopy.rawValue)\n", stderr)
        }
        
        return representation
    }
}

public struct FileRepresentation {
    let sourceFile: File
    let declarations: [Token]
}

public indirect enum Token {
    case ProtocolDeclaration(
        name: String,
        accessibility: Accessibility,
        range: Range<Int>,
        nameRange: Range<Int>,
        bodyRange: Range<Int>,
        children: [Token])

    case ClassDeclaration(
        name: String,
        accessibility: Accessibility,
        range: Range<Int>,
        nameRange: Range<Int>,
        bodyRange: Range<Int>,
        hasNoArgInit: Bool,
        children: [Token])
    
    case ProtocolMethod(
        name: String,
        accessibility: Accessibility,
        returnSignature: String,
        range: Range<Int>,
        nameRange: Range<Int>,
        parameters: [Token])
    
    case ClassMethod(
        name: String,
        accessibility: Accessibility,
        returnSignature: String,
        range: Range<Int>,
        nameRange: Range<Int>,
        bodyRange: Range<Int>,
        parameters: [Token])
    
    case MethodParameter(
        name: String,
        type: String,
        range: Range<Int>,
        nameRange: Range<Int>,
        attributes: [Token])
    
    case Attribute(type: Attributes)
    
    init?(representable: XPCRepresentable, source: String) {
        guard let dictionary = representable as? XPCDictionary else { return nil }
        
        // Common fields
        let name = dictionary[Key.Name.rawValue] as? String ?? "name not set"
        let kind = dictionary[Key.Kind.rawValue] as? String ?? dictionary[Key.Attribute.rawValue] as? String ?? "unknown type"
        
        
        // Optional fields
        let range = extractRange(dictionary, offsetKey: .Offset, lengthKey: .Length)
        let nameRange = extractRange(dictionary, offsetKey: .NameOffset, lengthKey: .NameLength)
        let bodyRange = extractRange(dictionary, offsetKey: .BodyOffset, lengthKey: .BodyLength)
        
        let accessibility = (dictionary[Key.Accessibility.rawValue] as? String).flatMap(Accessibility.init)
        let type = dictionary[Key.TypeName.rawValue] as? String
        
        switch kind {
        case Kinds.ProtocolDeclaration.rawValue:
            let children = (dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
                Token(representable: $0, source: source)
            }.filterNil()
            
            self = .ProtocolDeclaration(name: name, accessibility: accessibility!, range: range!, nameRange: nameRange!, bodyRange: bodyRange!, children: children)
        case Kinds.ClassDeclaration.rawValue:
            let children = (dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
                Token(representable: $0, source: source)
            }.filterNil()
            let initializers = children.map { child -> String? in
                    if case .ClassMethod(let name, _, _, _, _, _, _) = child {
                        return name
                    } else {
                        return nil
                    }
                }.filterNil().filter { $0.hasPrefix("init(") }
            let childrenWithoutInitializers = children.filter {
                if case .ClassMethod(let name, _, _, _, _, _, _) = $0 {
                    return !name.hasPrefix("init(")
                } else {
                    return true
                }
            }
            
            let hasNoArgInit = initializers.isEmpty || initializers.filter { $0 == "init()" }.isEmpty == false
            self = .ClassDeclaration(
                name: name,
                accessibility: accessibility!,
                range: range!,
                nameRange: nameRange!,
                bodyRange: bodyRange!,
                hasNoArgInit: hasNoArgInit,
                children: childrenWithoutInitializers)
            
        case Kinds.InstanceMethod.rawValue:
            let parameters = (dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
                Token(representable: $0, source: source)
            }.filterNil()
            
            // FIXME When bodyRange != nil, we need to create .Method instead of .ProtocolMethod
            var returnSignature: String
            if let bodyRange = bodyRange {
                returnSignature = source[nameRange!.endIndex..<bodyRange.startIndex].takeUntilStringOccurs("{")?.trimmed ?? ""
            } else {
                returnSignature = source[nameRange!.endIndex..<range!.endIndex].trimmed
                if returnSignature.isEmpty {
                    let returns = " -> Void"
                    let untilThrows = String(source.utf8.dropFirst(nameRange!.endIndex))?.takeUntilStringOccurs("throws").map {
                        $0 + "throws"
                    }?.trimmed
                    
                    if let untilThrows = untilThrows where untilThrows == "throws" || untilThrows == "rethrows" {
                        returnSignature = " \(untilThrows)"
                    }
                    returnSignature += returns
                }
            }
            
            if let bodyRange = bodyRange {
                self = .ClassMethod(name: name, accessibility: accessibility!, returnSignature: returnSignature, range: range!, nameRange: nameRange!, bodyRange: bodyRange, parameters: parameters)
            } else {
                self = .ProtocolMethod(name: name, accessibility: accessibility!, returnSignature: returnSignature, range: range!, nameRange: nameRange!, parameters: parameters)
            }
        case Kinds.MethodParameter.rawValue:
            let attributes: [Token]
            if let attributeDictionaries = dictionary[Key.Attributes.rawValue] as? XPCArray {
                attributes = attributeDictionaries.map {
                    Token(representable: $0, source: source)
                }.filterNil()
            } else {
                attributes = []
            }
            
            self = .MethodParameter(name: name, type: type!, range: range!, nameRange: nameRange!, attributes: attributes)
        case Kinds.AutoclosureAttribute.rawValue:
            let autoclosure = "@autoclosure" + source[0..<range!.startIndex].lookBackUntilStringOccurs("@autoclosure")!
            let escaping = autoclosure.containsString("escaping")
            if escaping {
                self = .Attribute(type: .escapingAutoclosure)
            } else {
                self = .Attribute(type: .autoclosure)
            }
        case Kinds.NoescapeAttribute.rawValue:
            self = .Attribute(type: .noescape)
        default:
            fputs("Unknown kind: \(kind)", stderr)
            return nil
        }
    }
}
