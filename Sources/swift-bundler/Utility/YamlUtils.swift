import Foundation

#if false
public enum YamlUtils {
  /// Replaces the incorrect swiftpm default args
  /// at the path to the .build/(debug/release).yaml
  /// file with a given triple.
  static func rewriteArgs(
    atPath pkgDirectory: URL,
    for configuration: BuildConfiguration, 
    with triple: String,
    platform: Platform
  ) {
    let pkgDir = pkgDirectory.absoluteString.replacingOccurrences(of: "file://", with: "")

    // this is the full yaml file path from swiftpm.
    var filePath = pkgDir.first == "/" ? String(pkgDir.dropFirst()) : pkgDir

    // add .build/(debug/release).yaml to the path.
    filePath += ".build/\(configuration.rawValue).yaml"

    log.info("GOT PATH: \(filePath)")
    log.info("GOT TRIPLE: \(triple)")

    // get the directory of the yaml file.
    let dir = "/" + filePath.components(separatedBy: "/").dropLast().joined(separator: "/")

    // file exists?
    if FileManager.default.fileExists(atPath: dir) {

      // get the file name.
      if let file = filePath.components(separatedBy: "/").last {

        var fileURL: URL
        // create a URL to the file.
        if #available(macOS 13.0, *) {
          fileURL = URL(filePath: dir.appending("/\(file)"))
        } else {
          // Fallback on earlier versions
          fileURL = URL(fileURLWithPath: dir.appending("/\(file)"))
        }

        do {
          // read in the file.
          var output = try String(contentsOf: fileURL, encoding: .utf8)

          // get the last part of the triple.
          for i in 0..<6 {
            // replace the gunk we don't want.
            output = output.replacingOccurrences(of: "macosx14.0", with: triple)
            output = output.replacingOccurrences(of: "macosx1\(i).0", with: triple)
            output = output.replacingOccurrences(of: "macosx10.1\(i)", with: triple)

            switch platform {
              case .iOS:
                output = output.replacingOccurrences(of: "MacOSX14.2", with: "iPhoneOS\(triple.replacingOccurrences(of: "ios", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX1\(i).\(i)", with: "iPhoneOS\(triple.replacingOccurrences(of: "ios", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX", with: "iPhoneOS")
              case .iOSSimulator:
                output = output.replacingOccurrences(of: "MacOSX14.2", with: "iPhoneSimulator\(triple.replacingOccurrences(of: "ios", with: "").replacingOccurrences(of: "-simulator", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX1\(i).\(i)", with: "iPhoneSimulator\(triple.replacingOccurrences(of: "ios", with: "").replacingOccurrences(of: "-simulator", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX", with: "iPhoneSimulator")
                output = output.replacingOccurrences(of: "arm64-apple-ios17.0-simulator", with: "arm64-apple-ios17.2-simulator")
                output = output.replacingOccurrences(of: "iPhoneSimulator17.0", with: "iPhoneSimulator17.2")
              case .visionOS:
                output = output.replacingOccurrences(of: "MacOSX14.2", with: "XROS\(triple.replacingOccurrences(of: "xros", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX1\(i).\(i)", with: "XROS\(triple.replacingOccurrences(of: "xros", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX", with: "XROS")
              case .visionOSSimulator:
                output = output.replacingOccurrences(of: "MacOSX14.2", with: "XRSimulator\(triple.replacingOccurrences(of: "xros", with: "").replacingOccurrences(of: "-simulator", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX1\(i).\(i)", with: "XRSimulator\(triple.replacingOccurrences(of: "xros", with: "").replacingOccurrences(of: "-simulator", with: ""))")
                output = output.replacingOccurrences(of: "MacOSX", with: "XRSimulator")
              default:
                break
            }
          }

          // write the file back out.
          try output.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
          // something went wrong.
          print("Could not write to \(file): \(error.localizedDescription)")
        }
      }
    }
  }
}
#endif /* false */
