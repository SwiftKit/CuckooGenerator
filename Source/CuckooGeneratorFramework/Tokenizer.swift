//
//  Parser.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework

public protocol Tokenizer {

    init(sourceFile: File)
    
    func tokenize() -> FileRepresentation
    
}
