//
//  .swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Method: Token {
    var name: String { get }
    var accessibility: Accessibility { get }
    var returnSignature: String { get }
    var range: Range<Int> { get }
    var nameRange: Range<Int> { get }
    var parameters: [MethodParameter] { get }
}