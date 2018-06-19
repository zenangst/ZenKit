import Foundation

public extension JSONDecoder {
  @available(iOS 10.0, *, OSX 10.12, *)
  convenience init(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) {
    self.init()
    self.dateDecodingStrategy = dateDecodingStrategy
  }
}
