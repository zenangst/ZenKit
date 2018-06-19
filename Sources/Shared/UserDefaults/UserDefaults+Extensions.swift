import Foundation

public extension UserDefaults {
  public subscript<T>(_ key: String) -> T? {
    get {
      switch T.self {
      case is Bool.Type:
        return bool(forKey: key) as? T
      case is Int.Type:
        return integer(forKey: key) as? T
      case is Float.Type:
        return float(forKey: key) as? T
      case is Double.Type:
        return double(forKey: key) as? T
      case is String.Type:
        return string(forKey: key) as? T
      case is Data.Type:
        return data(forKey: key) as? T
      case is URL.Type:
        return url(forKey: key) as? T
      case is [String].Type:
        return stringArray(forKey: key) as? T
      case is [AnyObject].Type:
        return array(forKey: key) as? T
      case is [String: AnyObject].Type:
        return dictionary(forKey: key) as? T
      default:
        return object(forKey: key) as? T
      }
    }
    set {
      guard let value = newValue else {
        return set(nil, forKey: key)
      }

      switch T.self {
      case is Bool.Type:
        return set((value as? Bool) ?? false, forKey: key)
      case is Int.Type:
        return set((value as? Int) ?? 0, forKey: key)
      case is Float.Type:
        return set((value as? Float) ?? 0, forKey: key)
      case is Double.Type:
        return set((value as? Double) ?? 0, forKey: key)
      case is URL.Type:
        return set(value as? URL, forKey: key)
      default:
        set(value, forKey: key)
      }
    }
  }
}
