//
//  VersionsCommand.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 17/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant
import Result

public struct RuntimeCommand: CommandType {
    
    public let verb = "runtime"
    public let function = "Prints supported runtime versions, or checks if a desired runtime is supported."
    
    public init() {
    }
    
    public func run(options: Options) -> Result<Void, CuckooGeneratorError> {
        if options.check.isEmpty == false {
            if let version = CuckooRuntimeVersion.fromString(options.check) {
                print("Requested runtime version \(version) is supported.")
                return .Success()
            } else {
                return .Failure(.RuntimeNotSupported(options.check))
            }
        } else {
            print("Runtime versions supported by this generator:")
            CuckooRuntimeVersion.all.forEach {
                print("    \($0)")
            }
            return .Success()
        }
    }
    
    public struct Options: OptionsType {
        let check: String
        
        public static func evaluate(m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            return Options.init
                <*> m <| Option(key: "check", defaultValue: "", usage: "Version of the Cuckoo runtime your project uses. Specify this option if you want to check if you need to update generator.")
        }
    }
}