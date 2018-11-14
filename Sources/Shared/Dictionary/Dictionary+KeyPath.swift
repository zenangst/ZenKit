import Foundation

public extension Dictionary {
  subscript(keyPath keyPath: String) -> Any? {
    get {
      guard let keyPath = Dictionary.keys(for: keyPath) else { return nil }
      return getValue(forKeyPath: keyPath)
    }
    set {
      guard let keyPath = Dictionary.keys(for: keyPath),
        let newValue = newValue else { return }
      self.setValue(newValue, forKeyPath: keyPath)
    }
  }

  static private func keys(for keyPath: String) -> [Key]? {
    let keys = keyPath.components(separatedBy: ".")
      .reversed()
      .compactMap({ $0 as? Key })
    return keys.isEmpty ? nil : keys
  }

  private func getValue(forKeyPath keyPath: [Key]) -> Any? {
    guard var value = self[keyPath.last!] else { return nil }

    if keyPath.count == 1 {
      return value
    }

    if let array = value as? Array<Any> {
      var newDictionary = [Key: Any]()
      for (index, val) in array.enumerated() {
        guard let key = String(index) as? Key else { continue }
        newDictionary[key] = val
      }

      if let newValue = newDictionary as? Value {
        value = newValue
      }
    }

    return (value as? [Key: Any]).flatMap { $0.getValue(forKeyPath: Array(keyPath.dropLast())) }
  }

  private mutating func setValue(_ value: Any, forKeyPath keyPath: [Key]) {
    if keyPath.count == 1 {
      (value as? Value).map { self[keyPath.last!] = $0 }
    } else if var subDictionary = self[keyPath.last!] as? [Key: Value] {
      guard self[keyPath.last!] != nil else { return }
      subDictionary.setValue(value, forKeyPath: Array(keyPath.dropLast()))
      (subDictionary as? Value).map { self[keyPath.last!] = $0 }
    } else {
      var dictionary = [Key: Value]()
      dictionary.setValue(value, forKeyPath: Array(keyPath.dropLast()))
      (dictionary as? Value).map { self[keyPath.last!] = $0 }
    }
  }

  public func enumFor<T: RawRepresentable>(keyPath: String) -> T? {
    guard let value = self[keyPath: keyPath] as? T.RawValue else { return nil }
    return T(rawValue: value)
  }

  public func valueFor<T>(keyPath: String) -> T? {
    return self[keyPath: keyPath] as? T
  }

  public func urlFor(keyPath: String) -> URL? {
    guard let urlString = self[keyPath: keyPath] as? String,
      let url = URL(string: urlString) else {
      return nil
    }

    return url
  }
}
