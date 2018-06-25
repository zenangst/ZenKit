import Foundation

public class BinarySearch<T> {
  public init() {}

  private func binarySearch<T>(_ collection: [T], lessThan: (T) -> Bool, predicate: (T) -> Bool) -> Int? {
    var lowerBound = 0
    var upperBound = collection.count

    while lowerBound < upperBound {
      let midIndex = lowerBound + (upperBound - lowerBound) / 2
      let element = collection[midIndex]

      if predicate(element) {
        return midIndex
      } else if lessThan(element) {
        lowerBound = midIndex + 1
      } else {
        upperBound = midIndex
      }
    }

    return nil
  }

  public func findElement<T>(in collection: [T],
                      lessThan: (T) -> Bool,
                      predicate: (T) -> Bool) -> T? {
    guard let firstMatchIndex = binarySearch(collection, lessThan: lessThan, predicate: predicate) else {
      return nil
    }

    var result: T?

    for element in collection[..<firstMatchIndex].reversed() {
      guard predicate(element) else { break }
      result = element
    }

    for element in collection[firstMatchIndex...] {
      guard predicate(element) else { break }
      result = element
    }

    return result
  }

  public func findElements<T>(in collection: [T],
                              lessThan: (T) -> Bool,
                              predicate: (T) -> Bool) -> [T]? {
    guard let firstMatchIndex = binarySearch(collection, lessThan: lessThan, predicate: predicate) else {
      return nil
    }

    var results = [T]()

    for element in collection[..<firstMatchIndex].reversed() {
      guard predicate(element) else { break }
      results.append(element)
    }

    for element in collection[firstMatchIndex...] {
      guard predicate(element) else { break }
      results.append(element)
    }

    return results
  }

  public func findElements<T>(in collection: [T],
                              lessThan: (T) -> Bool,
                              predicate: (T) -> Bool,
                              firstHalf: (T) -> Bool,
                              secondHalf: (T) -> Bool) -> [T]? {
    guard let firstMatchIndex = binarySearch(collection, lessThan: lessThan, predicate: predicate) else {
      return nil
    }

    var results = [T]()

    for element in collection[..<firstMatchIndex].reversed() {
      guard firstHalf(element) else { break }
      results.append(element)
    }

    for element in collection[firstMatchIndex...] {
      guard secondHalf(element) else { break }
      results.append(element)
    }

    return results
  }
}
