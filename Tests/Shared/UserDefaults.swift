import XCTest
import ZenKit

class UserDefaultsTests: XCTestCase {
  class MockStruct {}

  func testUserDefaults() {
    guard let userDefaults = UserDefaults(suiteName: "TestSuite") else {
      XCTFail("Could not create UserDefaults.")
      return
    }

    userDefaults["key"] = true
    XCTAssertEqual(userDefaults["key"], true)
    userDefaults["key"] = "value"
    XCTAssertEqual(userDefaults["key"], "value")
    userDefaults["key"] = Int(42)
    XCTAssertEqual(userDefaults["key"], Int(42))
    userDefaults["key"] = Double(42)
    XCTAssertEqual(userDefaults["key"], Double(42))
    userDefaults["key"] = Float(42)
    XCTAssertEqual(userDefaults["key"], Float(42))
    userDefaults["key"] = URL(string: "https://www.apple.com")
    XCTAssertEqual(userDefaults["key"], URL(string: "https://www.apple.com"))
    userDefaults["key"] = ["a", "b", "c"]
    XCTAssertEqual(userDefaults["key"], ["a", "b", "c"])
    userDefaults["key"] = ["foo": "bar"]
    XCTAssertEqual(userDefaults["key"], ["foo": "bar"])

    userDefaults.removeSuite(named: "TestSuite")
  }
}
