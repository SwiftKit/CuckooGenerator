//
//  Import.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 17.06.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct Import: Token {
    public let range: Range<Int>
    public let library: String
}