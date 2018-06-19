import XCTest
@testable import ZenKit

class UIOperationsiOSTests: XCTestCase {
  func testAnimatedCompletion() {
    let controller = OperationController<UIOperation>()
    let expectation = XCTestExpectation(description: "The operation should run.")
    var toggle: Bool = false

    controller.add(
      UIOperation(waitUntilDone: true) { operation in
        if #available(iOS 10.0, *) {
          __dispatch_assert_queue(DispatchQueue.main)
        }

        UIView.animate(withDuration: 2.0, animations: {}) { _ in
          operation.finish(true)
          toggle = true
        }
    }).execute {
      if #available(iOS 10.0, *) {
        __dispatch_assert_queue(DispatchQueue.main)
      }
      XCTAssertTrue(toggle)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
  }
}
