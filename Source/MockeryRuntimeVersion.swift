//
//  MockeryRuntimeVersion.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import MockeryGeneratorFramework
import Commandant

enum MockFileRevision: Int, ArgumentType {
    static let name: String = "Mockery mock file revision"
    static let latest: MockFileRevision = .r0
    
    case r0 = 0
    
    var generator: Generator.Type {
        switch self {
        case .r0:
            return Generator_r0.self
        }
    }
    
    static func fromString(string: String) -> MockFileRevision? {
        return Int(string).flatMap(MockFileRevision.init)
    }
}