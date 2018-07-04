import Foundation

public enum BinarySearchPredicate<T> {
  case equal(T)
  case less(T)
}

public extension Array {
  private func _binarySearch(_ predicate: (BinarySearchPredicate<Element>) -> Bool) -> Int? {
    var lowerBound = 0
    var upperBound = count

    while lowerBound < upperBound {
      let mid = lowerBound + (upperBound - lowerBound) / 2
      let midIndex = index(startIndex, offsetBy: mid)
      let element = self[midIndex]

      if predicate(.equal(element)) {
        return mid
      } else if predicate(.less(element)) {
        lowerBound = mid + 1
      } else {
        upperBound = mid
      }
    }

    return nil
  }

  public func binarySearchElement(_ predicate: (BinarySearchPredicate<Element>) -> Bool) -> Element? {
    guard let firstMatchIndex = _binarySearch(predicate) else { return nil }
    var result: Element?

    for element in self[..<firstMatchIndex].reversed() {
      guard predicate(.equal(element)) else { break }
      result = element
    }

    for element in self[firstMatchIndex...] {
      guard predicate(.equal(element)) else { break }
      result = element
    }

    return result
  }

  public func binarySearchElements(_ predicate: (BinarySearchPredicate<Element>) -> Bool) -> [Element]? {
    guard let firstMatchIndex = _binarySearch(predicate) else { return nil }
    var results = [Element]()
    for element in self[..<firstMatchIndex].reversed() {
      guard predicate(.equal(element)) else { break }
      results.append(element)
    }

    for element in self[firstMatchIndex...] {
      guard predicate(.equal(element)) else { break }
      results.append(element)
    }

    return results
  }
}
