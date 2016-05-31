//
//  String+Utility.swift
//  CuckooGenerator
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
    
    subscript(range: Range<Int>) -> String {
        let stringRange = startIndex.advancedBy(range.startIndex)..<startIndex.advancedBy(range.endIndex)
        return self[stringRange]
    }
}

extension SequenceType {
    
    func only<T>(type: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
    
    func noneOf<T>(type: T.Type) -> [Generator.Element] {
        return filter { !($0 is T) }
    }
}

internal func extractRange(dictionary: [String: SourceKitRepresentable], offsetKey: Key, lengthKey: Key) -> Range<Int>? {
    guard let
        offset = (dictionary[offsetKey.rawValue] as? Int64).map({ Int($0) }),
        length = (dictionary[lengthKey.rawValue] as? Int64).map({ Int($0) })
        else { return nil }
    
    return offset..<offset.advancedBy(length)
}