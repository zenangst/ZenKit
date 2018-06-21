import Foundation

public extension Dictionary {
  public var isValidJSON: Bool {
    return JSONSerialization.isValidJSONObject(self)
  }

  public func has(key: Key) -> Bool {
    return index(forKey: key) != nil
  }

  public func jsonData(pretty: Bool = false) -> Data? {
    guard isValidJSON else { return nil }
    return try? JSONSerialization.data(withJSONObject: self,
                                       options: _jsonOptions(pretty: pretty))
  }

  public func jsonString(pretty: Bool = false) -> String? {
    guard isValidJSON,
      let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                 options: _jsonOptions(pretty: pretty)) else {
                                                  return nil
    }
    return String(data: jsonData, encoding: .utf8)
  }

  private func _jsonOptions(pretty: Bool = false) -> JSONSerialization.WritingOptions {
    return pretty ? .prettyPrinted : []
  }
}
