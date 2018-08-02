import XCTest
import ZenKit

class GrandCentralDispatchTests: XCTestCase {
  func testDispatch() {
    let expectation = XCTestExpectation(description: "Wait for async to complete")
    GrandCentral.dispatch(.main) { return 10 }
      .dispatch(.background) { value -> String in return "\(value)" }
      .dispatch(.userInteractive) { value -> Int in
        Swift.print("\(value) \(type(of: value))")
        expectation.fulfill()
        return 20
    }
    wait(for: [expectation], timeout: 10.0)
  }
}
