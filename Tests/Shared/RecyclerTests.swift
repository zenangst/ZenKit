import XCTest
import ZenKit

class RecyclerTests: XCTestCase {
  class MockView: View {}

  func testDequeingView() {
    let frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
    let controller = DequeueController()
    let view1 = controller.dequeueView(of: MockView.self, { $0.init(frame: frame) })
    let view2 = controller.dequeueView(of: MockView.self, { $0.init(frame: frame) })

    XCTAssertEqual(view1, view2)
    XCTAssertEqual(view1.frame, frame)
    XCTAssertEqual(view2.frame, frame)

    let container = MockView()
    container.addSubview(view1)

    let view3 = controller.dequeueView(of: MockView.self, { $0.init(frame: frame) })
    XCTAssertEqual(view3.frame, frame)

    XCTAssertNotEqual(view1, view3)

    controller.purge()

    let view4 = controller.dequeueView(of: MockView.self, frame: frame)
    XCTAssertEqual(view4.frame, frame)

    XCTAssertNotEqual(view3, view4)
  }

  func testDequingWithIdentifier() {
    let frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
    let controller = DequeueController()

    controller.register(MockView.self, with: "mock")

    let view1 = try! controller.dequeueView(withIdentifier: "mock", { $0.init(frame: frame) })
    let view2 = try! controller.dequeueView(withIdentifier: "mock", { $0.init(frame: frame) })

    XCTAssertEqual(view1, view2)
    XCTAssertEqual(view1.frame, frame)
    XCTAssertEqual(view2.frame, frame)

    let container = MockView()
    container.addSubview(view1)

    let view3 = try! controller.dequeueView(withIdentifier: "mock", { $0.init(frame: frame) })
    XCTAssertEqual(view3.frame, frame)

    XCTAssertNotEqual(view1, view3)

    controller.purge()

    let view4 = try! controller.dequeueView(withIdentifier: "mock", frame: frame)
    XCTAssertEqual(view4.frame, frame)

    XCTAssertNotEqual(view3, view4)
  }
}
