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

struct GenerateMocksCommand: CommandType {
    
    let verb = "generate"
    let function = "Generates mock files"
    
    func run(options: Options) -> Result<(), MockeryGeneratorError> {
        let parsedFiles = options.files.map(File.init).map(Parser.parse)
        let headers = parsedFiles.map(FileHeaderHandler.getHeader(options.testableFrameworks))
        let mocks = parsedFiles.map(Generator.generate)
        let mergedFiles = zip(headers, mocks).map { $0 + $1.joinWithSeparator("\n") }
        
        let outputPath = Path(options.output)
        
        do {
            if outputPath.isDirectory {
                let inputPaths = parsedFiles.map(Path.init)
                for (inputPath, outputText) in zip(inputPaths, mergedFiles) {
                    let outputFile = TextFile(path: outputPath + inputPath.fileName)
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
        let files: [String]
        let output: String
        let testableFrameworks: [String]
        
        static func create(files: [String])(output: String)(testableFrameworks: String) -> Options {
            return Options(files: files, output: output, testableFrameworks: testableFrameworks.componentsSeparatedByString(","))
        }
        
        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<MockeryGeneratorError>> {
            return create
                <*> m <| Argument(usage: "Files to parse")
                <*> m <| Option(key: "output", usage: "Where to put the generated mocks. If a path to a directory is supplied, each input file will have a respective output file with mocks. If a path to a Swift file is supplied, all mocks will be in a single file.")
                <*> m <| Option(key: "testable", defaultValue: "", usage: "A comma separated list of frameworks that should be marked as @testable in the mock files.")
        }
    }
}