import XCTest
@testable import ZenKit

class DiffAlgorithmTests: XCTestCase {
  func testONP() {
    XCTAssertEqual(ONP(A: "foo", B: "bar").compose().editdis, 6)
    XCTAssertEqual(ONP(A: "foo", B: "foobar").compose().editdis, 3)
    XCTAssertEqual(ONP(A: "bar", B: "baz").compose().editdis, 2)
    XCTAssertEqual(ONP(A: "foobar", B: "bar").compose().editdis, -3)
    XCTAssertEqual(ONP(A: "Ihatepie", B: "Ilovepie").compose().editdis, 6)
  }
}
