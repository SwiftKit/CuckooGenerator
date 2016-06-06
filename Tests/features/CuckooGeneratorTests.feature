Feature: CuckooGeneratorTests
	Scenario: Generating test mocks
		When I run `runcuckoo generate --no-header --output Actual.swift ../../Tests/SourceFiles/TestedClass.swift ../../Tests/SourceFiles/TestedProtocol.swift`
		Then the file "../../Tests/SourceFiles/Expected.swift" should be equal to file "Actual.swift"