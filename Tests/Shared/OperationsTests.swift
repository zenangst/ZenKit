import XCTest
@testable import ZenKit

class UIOperationsTests: XCTestCase {
  func testBasicUIOperations() {
    let controller = OperationController<UIOperation>()
    let expectation = XCTestExpectation(description: "The operation should run.")
    var toggle: Bool = false

    controller.add(
      UIOperation { _ in
        if #available(iOS 10.0, *, OSX 10.12, *) {
          __dispatch_assert_queue(DispatchQueue.main)
        }
        toggle = true
    }).execute {
      if #available(iOS 10.0, *, OSX 10.12, *) {
        __dispatch_assert_queue(DispatchQueue.main)
      }
      XCTAssertTrue(toggle)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
  }

  func testSequenceOfUIOperations() {
    let controller = OperationController<UIOperation>()
    let expectation = XCTestExpectation(description: "All operations should complete.")
    var counter: Int = 0

    controller.execute {
      counter += 1
    }

    controller.execute(
      UIOperation { _ in
        counter += 1
      },
      UIOperation { _ in
        counter += 1
      },
      UIOperation { _ in
        XCTAssertEqual(counter, 3)
        expectation.fulfill()
      }
    )

    wait(for: [expectation], timeout: 3.0)
  }
}
