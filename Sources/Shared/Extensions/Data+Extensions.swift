import Foundation

public extension Data {
  public var bytes: [UInt8] { return [UInt8](self) }

  public func string(encoding: String.Encoding) -> String? {
    return String(data: self, encoding: encoding)
  }
}
