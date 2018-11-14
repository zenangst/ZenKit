import XCTest
import ZenKit

class Dictionary_ExtensionsTests: XCTestCase {

  func testGettingValuesByKeyPath() {
    let dictionary: [String: Any] = [
      "foo" : [
        "bar" : [
          "baz" : [1,2,3]
        ]
      ]
    ]

    XCTAssertTrue(dictionary[keyPath: "foo"] is [String: Any])
    XCTAssertTrue(dictionary[keyPath: "foo.bar"] is [String: Any])
    XCTAssertTrue(dictionary[keyPath: "foo.bar.baz"] is [Int])

    XCTAssertEqual(dictionary[keyPath: "foo.bar.baz.0"] as? Int, 1)
    XCTAssertEqual(dictionary[keyPath: "foo.bar.baz.1"] as? Int, 2)
    XCTAssertEqual(dictionary[keyPath: "foo.bar.baz.2"] as? Int, 3)
    XCTAssertNil(dictionary[keyPath: "foo.bar.baz.3"])
  }

  func testSettingValuesByKeyPath() {
    var testCase1: [String: Any] = [:]
    testCase1[keyPath: "foo"] = [String: Any]()
    XCTAssertTrue(testCase1[keyPath: "foo"] is [String: Any])

    var testCase2: [String: Any] = [:]
    testCase2[keyPath: "foo.bar"] = [String: Any]()
    XCTAssertTrue(testCase2[keyPath: "foo"] is [String: Any])
    XCTAssertTrue(testCase2[keyPath: "foo.bar"] is [String: Any])

    var testCase3: [String: Any] = [:]
    testCase3[keyPath: "foo.bar.baz"] = [1,2,3]
    XCTAssertTrue(testCase3[keyPath: "foo"] is [String: Any])
    XCTAssertTrue(testCase3[keyPath: "foo.bar"] is [String: Any])
    XCTAssertTrue(testCase3[keyPath: "foo.bar.baz"] is [Int])
    XCTAssertEqual(testCase3[keyPath: "foo.bar.baz.0"] as? Int, 1)
    XCTAssertEqual(testCase3[keyPath: "foo.bar.baz.1"] as? Int, 2)
    XCTAssertEqual(testCase3[keyPath: "foo.bar.baz.2"] as? Int, 3)
    XCTAssertNil(testCase3[keyPath: "foo.bar.baz.3"])
  }

  func testValueForKeyPath() {
    let dictionary: [String: Any] = [
      "foo" : [
        "bar" : [
          "baz" : [1,2,3]
        ]
      ]
    ]

    XCTAssertEqual(dictionary.valueFor(keyPath: "foo.bar.baz.0"), 1)
    XCTAssertEqual(dictionary.valueFor(keyPath: "foo.bar.baz.1"), 2)
    XCTAssertEqual(dictionary.valueFor(keyPath: "foo.bar.baz.2"), 3)
  }

  func testEnumForKeyPath() {
    enum MockEnum: Int {
      case foo = 1
      case bar = 2
      case baz = 3
    }

    let dictionary: [String: Any] = [
      "foo" : [
        "bar" : [
          "baz" : [1,2,3]
        ]
      ]
    ]

    XCTAssertEqual(dictionary.enumFor(keyPath: "foo.bar.baz.0"), MockEnum.foo)
    XCTAssertEqual(dictionary.enumFor(keyPath: "foo.bar.baz.1"), MockEnum.bar)
    XCTAssertEqual(dictionary.enumFor(keyPath: "foo.bar.baz.2"), MockEnum.baz)
  }

  func testUrlForKeyPath() {
    let dictionary: [String: Any] = [
      "urls" : [
        "https://www.nrk.no",
        "not a url"
      ]
    ]

    XCTAssertEqual(dictionary.urlFor(keyPath: "urls.0"),
                   URL(string: "https://www.nrk.no"))
    XCTAssertEqual(dictionary.urlFor(keyPath: "urls.1"),
                   nil)

  }
}
