import XCTest
import ZenKit

class BinarySearchTests: XCTestCase {
  func testFindingElement() {
    let binarySearch = BinarySearch<Int>()
    let expectedResult = 250_000
    let amount = 1_000_000
    var array = [Int]()
    for i in 0...amount {
      array.append(i)
    }

    /// Linear time test
    let linearStartTime = CFAbsoluteTimeGetCurrent()
    var linearResult = 0
    for i in array {
      if i == expectedResult {
        linearResult = i
        break
      }
    }
    XCTAssertEqual(linearResult, expectedResult)
    let linearTime = CFAbsoluteTimeGetCurrent() - linearStartTime
    Swift.print("🔍 Find \(expectedResult) in a collection of \(amount)")
    Swift.print("🚙 Linear search: \(linearTime)")

    /// Binary search test
    let binarySearchStartTime = CFAbsoluteTimeGetCurrent()
    let element = binarySearch.findElement(in: array, lessThan: { expectedResult > $0 },
                                           predicate: { expectedResult == $0 })
    XCTAssertEqual(element, expectedResult)

    let binarySearchTime = CFAbsoluteTimeGetCurrent() - binarySearchStartTime
    Swift.print("🏎 Binary search: \(binarySearchTime)")
    XCTAssertLessThan(binarySearchTime, linearTime)
  }

  func testFindingRange() {
    let binarySearch = BinarySearch<[CGRect]>()
    let size = CGSize(width: 50, height: 50)
    let viewport = CGRect(origin: .init(x: 0, y: 10000), size: .init(width: 375, height: 667))
    let amount = 10_000_000
    var array = [CGRect]()
    for i in 0...amount {
      let newRect = CGRect(origin: .init(x: 0, y: size.height * CGFloat(i)), size: size)
      array.append(newRect)
    }

    let binarySearchTime = benchmark(title: "🏎 Binary search using >= and <=") {
      let result = binarySearch.findElements(in: array,
                                             lessThan: { viewport.maxY > $0.minY },
                                             predicate: { $0.intersects(viewport) },
                                             firstHalf: { $0.maxY >= viewport.minY },
                                             secondHalf: { $0.minY <= viewport.maxY })
      XCTAssertEqual(result?.count, 15)
    }

    let binarySearchTimeWithIntersects = benchmark(title: "🚗 Binary search using intersects") {
      let result = binarySearch.findElements(in: array,
                                             lessThan: { viewport.maxY > $0.minY },
                                             predicate: { $0.intersects(viewport) })
      XCTAssertEqual(result?.count, 14)
    }

    let linearTime = benchmark(title: "🚙 Linear search") {
      var result = [CGRect]()
      for i in array {
        if i.intersects(viewport) {
          result.append(i)
        }
      }
      XCTAssertEqual(result.count, 14)
    }

    XCTAssertLessThan(binarySearchTime, linearTime)
    XCTAssertTrue(binarySearchTime > binarySearchTimeWithIntersects)
  }

  @discardableResult
  func benchmark(title: String, operation: () -> Void) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed)s")
    return timeElapsed
  }
}
