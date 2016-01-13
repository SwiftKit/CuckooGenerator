//
//  FileHeaderHandler.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SourceKittenFramework
import SwiftXPC

struct FileHeaderHandler {

    static func getHeader(testableFrameworks: [String])(file: FileRepresentation) -> String {
        let headerRange = 0..<minimumIndex(file.sourceFile.contents.characters.count, declarations: file.declarations)

        let generationInfo = "// MARK: - Mocks generated from file: \(file.sourceFile.path) at \(NSDate())\n"
        let header = generationInfo + file.sourceFile.contents[headerRange]
    
        return testableFrameworks.map { "import \($0)" }.reduce(header) {
            if let importRange = header.rangeOfString($1) {
                return $0.stringByReplacingCharactersInRange(importRange, withString: "@testable \($1)")
            } else {
                return $0
            }
        }
    }
    
    private static func minimumIndex(currentValue: Int, declarations: [Declaration]) -> Int {
        return declarations.reduce(currentValue) { minimum, declaration in
            switch declaration {
            case .ProtocolDeclaration(_, _, let range, _, _, let children):
                return minimumIndex(min(minimum, range.startIndex), declarations: children)
            case .ProtocolMethod(_, _, _, let range, _, let parameters):
                return minimumIndex(min(minimum, range.startIndex), declarations: parameters)
            case .MethodParameter(_, _, let range, _):
                return min(minimum, range.startIndex)
            }
        }
    }
    
}


//
//
///*
//var allow_showLoadingScreenWithViewUIViewIndicatorViewMessageString: Bool = false
//private(set) var timesCalled_showLoadingScreenWithViewUIViewIndicatorViewMessageString: Int = 0
//override func showLoadingScreen(view: UIView?, indicatorView: JGProgressHUDIndicatorView?, message: String)
//*/
//
//
//
//
//
//print("")
//print("")
//
//let fileHeaderRange = sourceFile.contents.startIndex..<sourceFile.contents.startIndex.advancedBy(fileHeaderLength)
//var fileHeader = sourceFile.contents[fileHeaderRange]
//for testableFramework in testableFrameworks {
//    if let importRange = fileHeader.rangeOfString("import \(testableFramework)") {
//        fileHeader.replaceRange(importRange, with: "@testable import \(testableFramework)")
//    }
//}
//
//let generatedMock = fileHeader + "\n" + generate(parsed).joinWithSeparator("\n")
//
//print(generatedMock)
//
//print("")
//print("")
//
////print(Structure(file: File(contents: generatedMock)))
//