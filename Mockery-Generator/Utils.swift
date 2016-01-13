//
//  String+Utility.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SwiftXPC

func += <T>(inout lhs: [T], rhs: T) {
    lhs.append(rhs)
}

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
    
    subscript(range: Range<Int>) -> String {
        let stringRange = startIndex.advancedBy(range.startIndex)..<startIndex.advancedBy(range.endIndex)
        return self[stringRange]
    }
}

extension SequenceType {

}

func extractRange(dictionary: XPCDictionary, offsetKey: Key, lengthKey: Key) -> Range<Int>? {
    guard let
        offset = (dictionary[offsetKey.rawValue] as? Int64).map({ Int($0) }),
        length = (dictionary[lengthKey.rawValue] as? Int64).map({ Int($0) })
        else { return nil }
    
    return offset..<offset.advancedBy(length)
}

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

protocol _OptionalProtocol {
    typealias WrappedType
    
    @warn_unused_result
    func optionalValue() -> WrappedType?
}

extension Optional: _OptionalProtocol {
    public typealias WrappedType = Wrapped
    
    @warn_unused_result
    public func optionalValue() -> WrappedType? {
        return self
    }
}

extension Optional where Wrapped: _OptionalProtocol {
    @warn_unused_result
    func flatten() -> Wrapped.WrappedType? {
        return flatMap { $0.optionalValue() }
    }
}

extension Array where Element: _OptionalProtocol {
    @warn_unused_result
    func filterNil() -> Array<Element.WrappedType> {
        return map { $0.optionalValue() }.filter { $0 != nil }.map { $0! }
    }
}