Feature: CuckooGeneratorTests
	Scenario: Generating test mocks
		When I run `runcuckoo generate --no-header --output Actual.swift ../SourceFiles/TestedClass.swift ../SourceFiles/TestedProtocol.swift`
		Then the file "../SourceFiles/Expected.swift" should be equal to file "Actual.swift"