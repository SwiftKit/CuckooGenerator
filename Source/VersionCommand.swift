//
//  VersionCommand.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 17/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant
import Result
import CuckooGeneratorFramework

struct VersionCommand: CommandType {
    static let appVersion = NSBundle.allFrameworks().filter {
        $0.bundleIdentifier == "org.brightify.CuckooGeneratorFramework"
    }.first?.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String ?? ""

    let verb = "version"
    let function = "Prints the version of this generator."
    
    func run(options: Options) -> Result<Void, CuckooGeneratorError> {
        print(VersionCommand.appVersion)
        return .Success()
    }
    
    struct Options: OptionsType {
        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            return .Success(Options())
        }
    }
}