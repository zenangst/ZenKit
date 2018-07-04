import XCTest
@testable import ZenKit

class SearchAlgorithmTests: XCTestCase {
  func testFindElement() {
    let binarySearch = BinarySearch<Int>()
    let interpolationSearch = InterpolationSearch<Int>()
    let expectedResult = 6_250_000
    let amount = 12_500_000
    var array = [Int]()

    for i in 0...amount {
      array.append(i + 10)
    }

    let linearTime = benchmark(title: "🚙 Linear search") {
      var result: Int = 0
      for i in array {
        if i == expectedResult {
          result = i
          break
        }
      }
      XCTAssertEqual(result, expectedResult)
    }

    let binarySearchTime = benchmark(title: "🏎 Binary search") {
      let result = binarySearch.findElement(in: array) { predicate -> Bool in
        switch predicate {
        case .equal(let element):
          return element == expectedResult
        case .less(let element):
          return element < expectedResult
        }
      }
      XCTAssertEqual(result, expectedResult)
    }

    let staticBinarySearchTime = benchmark(title: "🏎 Static Binary search") {
      let result = BinarySearch.findElement(in: array) { predicate -> Bool in
        switch predicate {
        case .equal(let element):
          return element == expectedResult
        case .less(let element):
          return element < expectedResult
        }
      }
      XCTAssertEqual(result, expectedResult)
    }

    let interpolationSearchTime = benchmark(title: "🧠 InterpolationSearch") {
      let result = interpolationSearch.findElement(in: array,
                                                   key: expectedResult, transform: { (value: Int) -> Int in
                                                    return value
      }) { predicate -> Bool in
        switch predicate {
        case .notEqual(let lhs, let rhs):
          return lhs != rhs
        case .equal(let element):
          return element != expectedResult
        case .less(let element, let key):
          return element < key
        case .more(let element, let key):
          return element > key
        }
      }
      XCTAssertEqual(result, expectedResult)
    }

    XCTAssertTrue(binarySearchTime < linearTime)
    XCTAssertTrue(interpolationSearchTime < linearTime)
    XCTAssertTrue(staticBinarySearchTime < binarySearchTime)
    XCTAssertTrue(interpolationSearchTime < binarySearchTime)
  }

  func testFindElements() {
    let binarySearch = BinarySearch<CGRect>()
    let interpolationSearch = InterpolationSearch<CGRect>()
    let size = CGSize(width: 50, height: 50)
    let viewport = CGRect(origin: .init(x: 0, y: 5000), size: .init(width: 375, height: 667))
    let amount = 25_750_000
    var array = [CGRect]()
    Swift.print("🚦 Generating \(amount) items")
    for i in 0...amount {
      let newRect = CGRect(origin: .init(x: 0, y: size.height * CGFloat(i)), size: size)
      array.append(newRect)
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

    var binarySearch1: [CGRect]?
    var binarySearch2: [CGRect]?
    var interpolationSearch1: [CGRect]?
    var interpolationSearch2: [CGRect]?
    var interpolationSearch3: [CGRect]?

    let binarySearchTime = benchmark(title: "🚗 Binary search") {
      let result = binarySearch.findElements(in: array) { predicate -> Bool in
        switch predicate {
        case .equal(let element):
          return element.intersects(viewport)
        case .less(let element):
          return viewport.maxY > element.minY
        }
      }

      binarySearch1 = result

      XCTAssertEqual(result?.count, 14)
    }

    let binarySearchStaticTime = benchmark(title: "🚗 Static Binary search") {
      let result = binarySearch.findElements(in: array) { predicate -> Bool in
        switch predicate {
        case .equal(let element):
          return element.intersects(viewport)
        case .less(let element):
          return viewport.maxY > element.minY
        }
      }

      binarySearch1 = result

      XCTAssertEqual(result?.count, 14)
    }

    let binarySearchTimeExtension = benchmark(title: "🏎 Binary search (extension)") {
      let result: [CGRect]? = array.binarySearchElements { predicate in
        switch predicate {
        case .equal(let element):
          return element.intersects(viewport)
        case .less(let element):
          return viewport.maxY > element.minY
        }
      }

      binarySearch2 = result

      XCTAssertEqual(result?.count, 14)
    }

    let interpolationSearchTime = benchmark(title: "🧠 Interpolation search") {
      let result = interpolationSearch.findElements(in: array, key: Int(viewport.minY), transform: { (rect) -> Int in
        return Int(rect.minY)
      }) { predicate -> Bool in
        switch predicate {
        case .notEqual(let lhs, let rhs):
          return lhs != rhs
        case .equal(let element):
          return element.intersects(viewport)
        case .less(let element, let key):
          return key > Int(element.minY)
        case .more(let element, let key):
          return key < Int(element.minY)
        }
      }

      interpolationSearch1 = result

      XCTAssertEqual(result?.count, 14)
    }

    let interpolationSearchStaticTime = benchmark(title: "🧠 Static Interpolation search") {
      let result = InterpolationSearch.findElements(in: array, key: Int(viewport.minY), transform: { (rect) -> Int in
        return Int(rect.minY)
      }) { predicate -> Bool in
        switch predicate {
        case .notEqual(let lhs, let rhs):
          return lhs != rhs
        case .equal(let element):
          return element.intersects(viewport)
        case .less(let element, let key):
          return key > Int(element.minY)
        case .more(let element, let key):
          return key < Int(element.minY)
        }
      }

      interpolationSearch3 = result

      XCTAssertEqual(result?.count, 14)
    }

    let interpolationSearchTimeExtension = benchmark(title: "☄️ Interpolation search (extension)") {
      let result = array.interpolationSearchElements(key: Int(viewport.minY), transform: { (rect) -> Int in
        return Int(rect.minY)
      }) { predicate -> Bool in
        switch predicate {
        case .notEqual(let lhs, let rhs):
          return lhs != rhs
        case .equal(let element):
          return element.intersects(viewport)
        case .less(let element, let key):
          return key > Int(element.minY)
        case .more(let element, let key):
          return key < Int(element.minY)
        }
      }

      interpolationSearch2 = result

      XCTAssertEqual(result?.count, 14)
    }

    XCTAssertTrue(binarySearchTime < linearTime)
    XCTAssertTrue(binarySearchTime > binarySearchTimeExtension)
    XCTAssertTrue(binarySearchTimeExtension > binarySearchStaticTime)
    XCTAssertTrue(binarySearchTime > interpolationSearchTime)
    XCTAssertTrue(interpolationSearchTime > interpolationSearchTimeExtension)
    XCTAssertTrue(interpolationSearchTimeExtension > interpolationSearchStaticTime)
    XCTAssertEqual(binarySearch1, binarySearch2)
    XCTAssertEqual(interpolationSearch1, interpolationSearch2)
    XCTAssertEqual(interpolationSearch1, interpolationSearch3)
  }
}
