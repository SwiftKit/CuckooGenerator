//
//  SourceDefinitions.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

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
}

enum Kinds: String {
    case ProtocolDeclaration = "source.lang.swift.decl.protocol"
    case InstanceMethod = "source.lang.swift.decl.function.method.instance"
    case MethodParameter = "source.lang.swift.decl.var.parameter"
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

public struct FileRepresentation {
    let sourceFile: File
    let declarations: [Declaration]
}

public indirect enum Declaration {
    case ProtocolDeclaration(
        name: String,
        accessibility: Accessibility,
        range: Range<Int>,
        nameRange: Range<Int>,
        bodyRange: Range<Int>,
        children: [Declaration])

    case ProtocolMethod(
        name: String,
        accessibility: Accessibility,
        returnSignature: String,
        range: Range<Int>,
        nameRange: Range<Int>,
        parameters: [Declaration])

    case MethodParameter(
        name: String,
        type: String,
        range: Range<Int>,
        nameRange: Range<Int>)
    
    init?(representable: XPCRepresentable, source: String) {
        guard let dictionary = representable as? XPCDictionary else { return nil }
        
        // Common fields
        let name = dictionary[Key.Name.rawValue] as! String
        let kind = dictionary[Key.Kind.rawValue] as! String
        
        
        // Optional fields
        let range = extractRange(dictionary, offsetKey: .Offset, lengthKey: .Length)
        let nameRange = extractRange(dictionary, offsetKey: .NameOffset, lengthKey: .NameLength)
        let bodyRange = extractRange(dictionary, offsetKey: .BodyOffset, lengthKey: .BodyLength)
        
        let accessibility = (dictionary[Key.Accessibility.rawValue] as? String).flatMap(Accessibility.init)
        let type = dictionary[Key.TypeName.rawValue] as? String
        
        //        if offset < fileHeaderLength {
        //            fileHeaderLength = offset
        //        }
        //
        
        switch kind {
        case Kinds.ProtocolDeclaration.rawValue:
            let children = (dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
                Declaration(representable: $0, source: source)
            }.filterNil()
            
            self = .ProtocolDeclaration(name: name, accessibility: accessibility!, range: range!, nameRange: nameRange!, bodyRange: bodyRange!, children: children)
        case Kinds.InstanceMethod.rawValue:
            let parameters = (dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
                Declaration(representable: $0, source: source)
            }.filterNil()
            
            
            // FIXME When bodyRange != nil, we need to create .Method instead of .ProtocolMethod
            let returnSignature: String
            if let bodyRange = bodyRange {
                returnSignature = source[nameRange!.endIndex..<bodyRange.startIndex]
            } else {
                returnSignature = source[nameRange!.endIndex..<range!.endIndex]
            }
            
            self = .ProtocolMethod(name: name, accessibility: accessibility!, returnSignature: returnSignature, range: range!, nameRange: nameRange!, parameters: parameters)
        case Kinds.MethodParameter.rawValue:
            self = .MethodParameter(name: name, type: type!, range: range!, nameRange: nameRange!)
        default:
            fputs("Unknown kind: \(kind)", stderr)
            return nil
        }
        
    }
}
