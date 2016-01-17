//
//  MockeryRuntimeVersion.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant

public enum CuckooRuntimeVersion: String {
    public static let latest: CuckooRuntimeVersion = .v0_1_0
    public static let all: [CuckooRuntimeVersion] = [.v0_1_0]
    
    case v0_1_0 = "0.1.0"
    
    public var generator: Generator.Type {
        switch self {
        case .v0_1_0:
            return Generator_r1.self
        }
    }
    
    public var tokenizer: Tokenizer.Type {
        switch self {
        case .v0_1_0:
            return Tokenizer_r1.self
        }
    }
    
    public var fileHeaderHandler: FileHeaderHandler.Type {
        switch self {
        case .v0_1_0:
            return FileHeaderHandler_r1.self
        }
    }
}

extension CuckooRuntimeVersion: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

extension CuckooRuntimeVersion: ArgumentType {
    public static let name: String = "Mockery runtime version"
    
    public static func fromString(string: String) -> CuckooRuntimeVersion? {
        return CuckooRuntimeVersion(rawValue: string)
    }
}