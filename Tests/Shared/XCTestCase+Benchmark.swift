import XCTest

extension XCTestCase {
  @discardableResult
  func benchmark(title: String, operation: () -> Void) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed)s")
    return timeElapsed
  }
}
