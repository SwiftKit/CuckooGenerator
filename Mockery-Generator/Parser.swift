//
//  Parser.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework
import SwiftXPC

struct Parser {
    
    static func parse(sourceFile: File) -> FileRepresentation {
        let structure = Structure(file: sourceFile)
        
        let declarations = (structure.dictionary[Key.Substructure.rawValue] as? XPCArray ?? []).map {
            Declaration(representable: $0, source: sourceFile.contents)
        }.filterNil()
        
        return FileRepresentation(sourceFile: sourceFile, declarations: declarations)
    }

}