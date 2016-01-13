//
//  GenerateMocksCommand.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework
import FileKit
import MockeryGeneratorFramework

struct GenerateMocksCommand: CommandType {
    
    let verb = "generate"
    let function = "Generates mock files"
    
    func run(options: Options) -> Result<(), MockeryGeneratorError> {
        let parsedFiles = options.files.map { File(path: $0) }.filterNil().map(Parser.parse)
        let headers = parsedFiles.map(FileHeaderHandler.getHeader(options.testableFrameworks))
        let mocks = parsedFiles.map(options.revision.generator.generate)
        let mergedFiles = zip(headers, mocks).map { $0 + $1.joinWithSeparator("\n") }
        
        let outputPath = Path(options.output)
        
        do {
            if outputPath.isDirectory {
                let inputPaths = options.files.map { Path($0) }
                for (inputPath, outputText) in zip(inputPaths, mergedFiles) {
                    let outputFile = TextFile(path: outputPath + inputPath.fileName)
                    print(outputText, outputFile)
                    try outputText |> outputFile
                }
            } else {
                let outputFile = TextFile(path: outputPath)
                try mergedFiles.joinWithSeparator("\n\n") |> outputFile
            }
        } catch let error as FileKitError {
            return .Failure(.IOError(error))
        } catch let error {
            return .Failure(.UnknownError(error))
        }
        
        return .Success()
    }
    
    
    struct Options: OptionsType {
        let revision: MockFileRevision
        let files: [String]
        let output: String
        let testableFrameworks: [String]
        
        static func create(revision: MockFileRevision)(output: String)(testableFrameworks: String)(files: [String]) -> Options {
            return Options(revision: revision, files: files, output: output, testableFrameworks: testableFrameworks.componentsSeparatedByString(",").filter { !$0.isEmpty })
        }
        
        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<MockeryGeneratorError>> {
            return create
                <*> m <| Option(key: "revision", defaultValue: MockFileRevision.latest, usage: "Revision of the generated files. Different versions of Mockery runtime can work with different mock files revisions.")
                <*> m <| Option(key: "output", usage: "Where to put the generated mocks.\nIf a path to a directory is supplied, each input file will have a respective output file with mocks.\nIf a path to a Swift file is supplied, all mocks will be in a single file.")
                <*> m <| Option(key: "testable", defaultValue: "", usage: "A comma separated list of frameworks that should be imported as @testable in the mock files.")
                <*> m <| Argument(usage: "Files to parse and generate mocks for")
        }
    }
}