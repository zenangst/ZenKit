import Foundation

public extension Array {
  public var hasElements: Bool { return !isEmpty }

  public func first<T>(as: T.Type) -> T? {
    return first(where: { $0 is T }) as? T
  }
}
