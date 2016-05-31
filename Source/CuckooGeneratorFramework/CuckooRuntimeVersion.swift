//
//  CuckooRuntimeVersion.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant

public enum CuckooRuntimeVersion: String {
    public static let latest: CuckooRuntimeVersion = .v0_4_1
    public static let all: [CuckooRuntimeVersion] = [.v0_1_0, .v0_3_0, .v0_4_0, .v0_4_1]

    case v0_1_0 = "0.1.0"
    case v0_3_0 = "0.3.0"
    case v0_4_0 = "0.4.0"
    case v0_4_1 = "0.4.1"

    public var generator: Generator.Type {
        switch self {
        case .v0_1_0:
            return Generator_r1.self
        case .v0_3_0, .v0_4_0:
            return Generator_r2.self
        case .v0_4_1:
            return Generator_r3.self
        }
    }

    public var tokenizer: Tokenizer.Type {
        switch self {
        case .v0_1_0, .v0_3_0, v0_4_0, .v0_4_1:
            return Tokenizer_r1.self
        }
    }

    public var fileHeaderHandler: FileHeaderHandler.Type {
        switch self {
        case .v0_1_0, .v0_3_0, v0_4_0, .v0_4_1:
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
    public static let name: String = "Cuckoo runtime version"

    public static func fromString(string: String) -> CuckooRuntimeVersion? {
        return CuckooRuntimeVersion(rawValue: string)
    }
}
