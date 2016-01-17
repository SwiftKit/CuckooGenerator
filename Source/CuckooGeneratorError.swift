//
//  MockeryGeneratorError.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import FileKit

enum CuckooGeneratorError: ErrorType {
    case IOError(FileKitError)
    case UnknownError(ErrorType)
    case RuntimeNotSupported(String)
    
    var description: String {
        switch self {
        case .IOError(let error):
            return error.description
        case .UnknownError(let error):
            return "\(error)"
        case .RuntimeNotSupported(let runtime):
            
            return "Requested runtime version \(runtime) is not supported by this generator version \(VersionCommand.appVersion)."
        }
    }
}