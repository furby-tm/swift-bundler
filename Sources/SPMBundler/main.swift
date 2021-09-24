import Foundation
import ArgumentParser

enum BuildConfiguration: String {
  case debug
  case release
}

struct Bundler: ParsableCommand {
  static let configuration = CommandConfiguration(subcommands: [Init.self, GenerateXcodeproj.self, Build.self])
}

Bundler.main()

// TODO: fix release build metallibs
// TODO: option to show build progress in a window
// TODO: codesigning
// TODO: graceful shutdown
// TODO: documentation
// TODO: make the default main.swift more useful (just a SwiftUI hello world or something)
// TODO: respect build configuration from xcode (debug|release)

// Must contain a main.swift otherwise it won't compile as an executable
// 