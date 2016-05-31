//
//  ProtocolDeclaration.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ProtocolDeclaration: ContainerToken {
    public let name: String
    public let accessibility: Accessibility
    public let range: Range<Int>
    public let nameRange: Range<Int>
    public let bodyRange: Range<Int>
    public let initializers: [Initializer]
    public let children: [Token]
    public let implementation: Bool = false
}