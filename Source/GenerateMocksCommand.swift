//
//  GenerateMocksCommand.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant
import Result
import SourceKittenFramework
import FileKit
import CuckooGeneratorFramework

public struct GenerateMocksCommand: CommandType {
    
    public let verb = "generate"
    public let function = "Generates mock files"
    
    public func run(options: Options) -> Result<Void, CuckooGeneratorError> {
        let parsedFiles = options.files.map { File(path: $0) }.flatMap { $0 }.map { Tokenizer(sourceFile: $0).tokenize() }
        let headers = parsedFiles.map { f in options.noHeader ? [] : FileHeaderHandler.getHeader(f) }
        let imports = parsedFiles.map { f in FileHeaderHandler.getImports(options.testableFrameworks) }
        let mocks = parsedFiles.map(Generator.generate)
        let mergedFiles = zip(zip(headers, imports), mocks).map { $0.0 + $0.1 + $1 }.map { $0.joinWithSeparator("\n") }
        
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
    
    
    public struct Options: OptionsType {
        let files: [String]
        let output: String
        let noHeader: Bool
        let testableFrameworks: [String]
        
        public static func create(output: String)(testableFrameworks: String)(noHeader: Bool)(files: [String]) -> Options {
            return Options(files: files, output: output, noHeader: noHeader, testableFrameworks: testableFrameworks.componentsSeparatedByString(",").filter { !$0.isEmpty })
        }
        
        public static func evaluate(m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            return create
                <*> m <| Option(key: "output", defaultValue: "GeneratedMocks.swift", usage: "Where to put the generated mocks.\nIf a path to a directory is supplied, each input file will have a respective output file with mocks.\nIf a path to a Swift file is supplied, all mocks will be in a single file.")
                <*> m <| Option(key: "testable", defaultValue: "", usage: "A comma separated list of frameworks that should be imported as @testable in the mock files.")
                <*> m <| Option(key: "no-header", defaultValue: false, usage: "Do not generate file headers.")
                <*> m <| Argument(usage: "Files to parse and generate mocks for.")
        }
    }
}