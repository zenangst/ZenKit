import XCTest
@testable import ZenKit

class AlgorithmTests: XCTestCase {
  func testBinarySearchVSInterpolationSearch() {
    let binarySearch = BinarySearch<Int>()
    let interpolationSearch = InterpolationSearch()
    let expectedResult = 12_500_000 / 2
    let amount = 12_500_000
    let array: [Int] = Array(0...amount)

    let binarySearchTime = benchmark(title: "🏎 Binary search") {
      let result = binarySearch.findElement(in: array,
                                            lessThan: { $0 < expectedResult },
                                            predicate: { $0 == expectedResult })
      XCTAssertEqual(result, expectedResult)
    }

    let interpolationSearchTime = benchmark(title: "🧠 InterpolationSearch") {
      let result = interpolationSearch.findElement(in: array, key: expectedResult,
                                                   lowPredicate: { expectedResult >= $0 },
                                                   highPredicate: { expectedResult <= $0  })
      XCTAssertEqual(result, expectedResult)
    }

    XCTAssertTrue(interpolationSearchTime < binarySearchTime)
  }

  @discardableResult
  private func benchmark(title: String, operation: () -> Void) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed)s")
    return timeElapsed
  }
}
