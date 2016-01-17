//
//  Tokenizer_r0.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework
import SwiftXPC

struct Tokenizer_r0: Tokenizer {
    
    static func tokenize(sourceFile: File) -> FileRepresentation {
        let structure = Structure(file: sourceFile)
        
        let declarations = (structure.dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
            Token(representable: $0, source: sourceFile.contents)
        }.filterNil()
        
        return FileRepresentation(sourceFile: sourceFile, declarations: declarations)
    }
    
}