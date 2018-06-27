import Foundation

public class BinarySearch<T> {
  public enum BinarySearchPredicate<T> {
    case equal(T)
    case less(T)
  }

  public init() {}

  private func _search(_ collection: [T],
                          predicate: (BinarySearchPredicate<T>) -> Bool) -> Int? {
    var lowerBound = 0
    var upperBound = collection.count

    while lowerBound < upperBound {
      let midIndex = lowerBound + (upperBound - lowerBound) / 2
      let element = collection[midIndex]

      if predicate(.equal(element)) {
        return midIndex
      } else if predicate(.less(element)) {
        lowerBound = midIndex + 1
      } else {
        upperBound = midIndex
      }
    }

    return nil
  }

  public func findElement(in collection: [T],
                             predicate: (BinarySearchPredicate<T>) -> Bool) -> T? {
    guard let firstMatchIndex = _search(collection, predicate: predicate) else { return nil }
    var result: T?
    for element in collection[..<firstMatchIndex].reversed() {
      guard predicate(.equal(element)) else { break }
      result = element
    }

    for element in collection[firstMatchIndex...] {
      guard predicate(.equal(element)) else { break }
      result = element
    }

    return result
  }

  public func findElements(in collection: [T],
                              predicate: (BinarySearchPredicate<T>) -> Bool) -> [T]? {
    guard let firstMatchIndex = _search(collection, predicate: predicate) else { return nil }
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
