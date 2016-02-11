# Cuckoo generator
Generator of Mocks for [Cuckoo](https://github.com/SwiftKit/Cuckoo).

## What is supported
  - `protocol` mocking
    - Instance methods
    - Instance properties
  - `class` mocking
    - Instance methods
    - Instance properties
  - Copy file header (everything before first protocol/class/struct = imports, comments etc.)
  - `throws` and `rethrows`
  - Add specified `@testable import` statements to the generated files.
  - Selecting which files to mock

## What is not yet supported
  - static variables
  - Static methods
  - Generics
  - global functions

## What will not be supported
  - `struct` mocking
      - workaround is to use a common protocol
  - `final class` mocking
  - `private` variables and methods
  - global constants

## Installation
To

## How to run

First you need to run:

```
carthage update
```

after the dependencies are downloaded and compiled, you just need to do:

```
chmod +x main.swift
./main.swift
```
