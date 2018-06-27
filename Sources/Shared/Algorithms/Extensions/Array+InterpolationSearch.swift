import Foundation

public enum InterpolationPredicate<T> {
  case notEqual(T, T)
  case equal(T)
  case less(T, Int)
  case more(T, Int)
}

public extension Array {
  private func _search(key: Int,
                       transform: (Element) -> Int,
                       predicate: (InterpolationPredicate<Element>) -> Bool) -> Int? {
    var lowBound = 0
    var upperBound = count - 1
    var mid: Int

    while predicate(.notEqual(self[upperBound], self[lowBound])) &&
      predicate(.less(self[lowBound], key)) &&
      predicate(.more(self[upperBound], key)) {
        let lowValue = transform(self[lowBound])
        let highValue = transform(self[upperBound])

        mid = lowBound + ((key - lowValue) * (upperBound - lowBound) / (highValue - lowValue))

        if predicate(.less(self[mid], key)) {
          lowBound = mid + 1
        } else if predicate(.more(self[mid], key)) {
          upperBound = mid - 1
        } else {
          return mid
        }
    }

    if predicate(.equal(self[lowBound])) {
      return lowBound
    } else {
      return -1
    }
  }

  public func interpolationSearchElement(key: Int,
                                         transform: (Element) -> Int,
                                         predicate: (InterpolationPredicate<Element>) -> Bool) -> Element? {
    guard let firstMatchIndex = _search(key: key,
                                        transform: transform,
                                        predicate: predicate) else { return nil }
    return self[firstMatchIndex]
  }

  public func interpolationSearchElements(key: Int,
                                          transform: (Element) -> Int,
                                          predicate: (InterpolationPredicate<Element>) -> Bool) -> [Element]? {
    guard let firstMatchIndex = _search(key: key,
                                        transform: transform,
                                        predicate: predicate) else { return nil }
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
