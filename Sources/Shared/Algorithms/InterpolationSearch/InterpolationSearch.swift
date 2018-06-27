import Foundation

public class InterpolationSearch<T> {
  public enum InterpolationPredicate<T> {
    case notEqual(T, T)
    case equal(T)
    case less(T, Int)
    case more(T, Int)
  }

  public init() {}

  private func _search<T>(in collection: [T],
                          key: Int,
                          transform: (T) -> Int,
                          predicate: (InterpolationPredicate<T>) -> Bool) -> Int? {
    var lowBound = 0
    var upperBound = collection.count - 1
    var mid: Int
    var steps = 0
    defer { Swift.print("Steps: \(steps)") }

    while predicate(.notEqual(collection[upperBound], collection[lowBound])) &&
      predicate(.less(collection[lowBound], key)) &&
      predicate(.more(collection[upperBound], key)) {
        defer { steps += 1 }

        let lowValue = transform(collection[lowBound])
        let highValue = transform(collection[upperBound])

        mid = lowBound + ((key - lowValue) * (upperBound - lowBound) / (highValue - lowValue))

        if predicate(.less(collection[mid], key)) {
          lowBound = mid + 1
        } else if predicate(.more(collection[mid], key)) {
          upperBound = mid - 1
        } else {
          return mid
        }
    }

    if predicate(.equal(collection[lowBound])) {
      return lowBound
    } else {
      return -1
    }
  }

  public func findElement<T>(in collection: [T],
                             key: Int,
                             transform: (T) -> Int,
                             predicate: (InterpolationPredicate<T>) -> Bool) -> T? {
    guard let firstMatchIndex = _search(in: collection, key: key,
                                        transform: transform,
                                        predicate: predicate) else {
                                          return nil
    }

    return collection[firstMatchIndex]
  }

  public func findElements<T>(in collection: [T],
                              key: Int,
                              transform: (T) -> Int,
                              predicate: (InterpolationPredicate<T>) -> Bool) -> [T]? {
    guard let firstMatchIndex = _search(in: collection, key: key,
                                        transform: transform,
                                        predicate: predicate) else {
                                          return nil
    }

    var results = [T]()

    for element in collection[..<firstMatchIndex].reversed() {
      guard predicate(.equal(element)) else { break }
      results.append(element)
    }

    for element in collection[firstMatchIndex...] {
      guard predicate(.equal(element)) else { break }
      results.append(element)
    }

    return results
  }
}
