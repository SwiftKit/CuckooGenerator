//
//  String+Utility.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import SourceKittenFramework

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
    
    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func containsWord(word: String) -> Bool {
        let separated = componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return separated.contains(word)
    }
    
    func takeUntilStringOccurs(occurence: String) -> String? {
        return self.componentsSeparatedByString(occurence).first
    }
    
    func takeAfterStringOccurs(occurence: String) -> String? {
        let output = self.componentsSeparatedByString(occurence).dropFirst().joinWithSeparator(occurence)
        return output.isEmpty ? nil : output
    }
    
    func lookBackUntilStringOccurs(occurence: String) -> String? {
        return self.componentsSeparatedByString(occurence).last
    }
    
    func lookBackAfterStringOccurs(occurence: String) -> String? {
        let output = self.componentsSeparatedByString(occurence).dropLast().joinWithSeparator(occurence)
        return output.isEmpty ? nil : output
    }
    
    subscript(range: Range<Int>) -> String {
        let stringRange = startIndex.advancedBy(range.startIndex)..<startIndex.advancedBy(range.endIndex)
        return self[stringRange]
    }
}

extension SequenceType {
    
    func only<T>(type: T.Type) -> [T] {
        return map { $0 as? T }.filterNil()
    }
    
    func noneOf<T>(type: T.Type) -> [Generator.Element] {
        return filter { !($0 is T) }
    }
}

func extractRange(dictionary: [String: SourceKitRepresentable], offsetKey: Key, lengthKey: Key) -> Range<Int>? {
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

func keyValueArrayToTupleArray(keyValueArray: [String]) -> [(String, String)] {
    var output: [(String, String)] = []
    var current: (key: String, value: String) = ("", "")
    for (index, keyValue) in keyValueArray.enumerate() {
        if index % 2 == 0 {
            current = (keyValue, "")
        } else {
            current.value = keyValue
            output.append(current)
        }
    }
    return output
}

public protocol _OptionalProtocol {
    associatedtype WrappedType
    
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

public extension Array where Element: _OptionalProtocol {
    @warn_unused_result
    public func filterNil() -> Array<Element.WrappedType> {
        return map { $0.optionalValue() }.filter { $0 != nil }.map { $0! }
    }
}