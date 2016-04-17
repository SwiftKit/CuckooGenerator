//
//  SourceDefinitions.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import SourceKittenFramework

enum Key: String {
    case Substructure = "key.substructure"
    case Kind = "key.kind"
    case Accessibility = "key.accessibility"
    case SetterAccessibility = "key.setter_accessibility"
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
    case InstanceVariable = "source.lang.swift.decl.var.instance"
    
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

public protocol Token { }

public protocol ContainerToken: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var range: Range<Int> { get }
    var nameRange: Range<Int> { get }
    var bodyRange: Range<Int> { get }
    var initializers: [Initializer] { get }
    var children: [Token] { get }
    var implementation: Bool { get }
}

public struct ProtocolDeclaration: ContainerToken {
    // MARK: ContainerToken
    public let name: String
    public let accessibility: Accessibility
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let bodyRange: Range<Int>
    public let initializers: [Initializer]
    public let children: [Token]
    public let implementation: Bool = false
}

public struct ClassDeclaration: ContainerToken {
    // MARK: ContainerToken
    public let name: String
    public let accessibility: Accessibility
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let bodyRange: Range<Int>
    public let initializers: [Initializer]
    public let children: [Token]
    public let implementation: Bool = true
    
    // MARK: Class declaration
    public var hasNoArgInit: Bool {
        return initializers.filter { $0.parameters.isEmpty }.isEmpty
    }
}

public protocol Method: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var returnSignature: String { get }
    var range: Range<Int> { get }
    var nameRange: Range<Int> { get }
    var parameters: [MethodParameter] { get }
}

public struct ProtocolMethod: Method {
    // MARK: Method
    public let name: String
    public let accessibility: Accessibility
    public let returnSignature: String
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let parameters: [MethodParameter]
}

public struct Initializer: Method {
    // MARK: Method
    public let name: String
    public let accessibility: Accessibility
    public let returnSignature: String
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let parameters: [MethodParameter]
    
    // MARK: Initializer
    public let required: Bool
}

public struct ClassMethod: Method {
    // MARK: Method
    public let name: String
    public let accessibility: Accessibility
    public let returnSignature: String
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let parameters: [MethodParameter]

    // MARK: Class method
    public let bodyRange: Range<Int>
}

public struct InstanceVariable: Token {
    public var name: String
    public var type: String
    public var accessibility: Accessibility
    public var setterAccessibility: Accessibility?
    public var range: Range<Int>
    public var nameRange: Range<Int>
    public var overriding: Bool
    
    public var readOnly: Bool {
        return setterAccessibility == nil
    }
}

public struct MethodParameter: Token {
    public let label: String?
    public let name: String
    public let type: String
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let attributes: Attributes
    
    func labelAndNameAtPosition(position: Int) -> String {
        let isFirst = position == 0
        if let label = label {
            return label != name || isFirst ? "\(label) \(name)" : name
        } else {
            return isFirst ? name : "_ \(name)"
        }
    }
    
    func labelOrNameAtPosition(position: Int) -> String {
        let isFirst = position == 0
        if let label = label {
            return label
        } else if isFirst {
            return ""
        } else {
            return name
        }
    }
    
    func labelNameOrPositionAtPosition(position: Int) -> String {
        let label = labelOrNameAtPosition(position)
        return label.isEmpty ? "\(position)" : label
    }
}