import Foundation

public extension Collection {
  // Returns true if the collection is not empty.
  public var isNotEmpty: Bool { return !isEmpty }
  // Returns true if the collection has one object.
  public var hasOne: Bool { return count == 1 }
  // Returns true if the collection has more than one object.
  public var hasMany: Bool { return count > 1 }

  public func first<T>(as: T.Type) -> T? {
    return first(where: { $0 is T }) as? T
  }
}
