import Foundation

public class InterpolationSearch {
  public init() {}

  public func findElement(in array: [Int],
                          key: Int,
                          lowPredicate: (Int) -> Bool,
                          highPredicate: (Int) -> Bool) -> Int? {
    var low = 0
    var high = array.count - 1
    var mid: Int
    var steps = 0
    defer { Swift.print("Steps: \(steps)") }

    while array[high] != array[low] &&
      lowPredicate(array[low]) &&
      highPredicate(array[high]) {
        defer { steps += 1 }

        mid = low + ((key - array[low]) * (high - low) / (array[high] - array[low]))

        if array[mid] < key {
          low = mid + 1
        } else if key < array[mid] {
          high = mid - 1
        } else {
          return mid
        }
    }

    if key == array[low] {
      return low
    } else {
      return -1
    }
  }
}
