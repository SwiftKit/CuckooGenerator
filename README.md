# Mockery-Generator
Generator of Mocks for Mockery

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

## What is supported
  - `protocol`
    - Instance methods
  - Copy file header (everything before first protocol/class/struct = imports, comments etc.)
  - `throws` and `rethrows`
  - Replace specified `import`s with `@testable import`.

## What is not supported
  - Selecting which files to mock
  - `struct`
  - `class`
  - Static methods
  - Generics

## Future
  - Use of Mockery APIs instead of the currently generated ugly ones.
  - Providing custom method implementations
  - Optimizations
    - i.e. making the generated mock a `struct` instead of a `class` when possible
  - Command line parameters