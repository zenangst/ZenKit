import XCTest
import CoreData
import ZenKit

@objc(User)
class User: NSManagedObject {
  @objc dynamic var firstName: String?
  @objc dynamic var lastName: String?
}

class CoreDataTests: XCTestCase {
  lazy var coordinator: NSPersistentStoreCoordinator = .init(managedObjectModel: model)
  lazy var model: NSManagedObjectModel = {
    let model = NSManagedObjectModel()
    model.entities = [User.entity]
    return model
  }()
  lazy var context: NSManagedObjectContext = {
    _ = try! self.coordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                            configurationName: nil,
                                            at: nil,
                                            options: nil)
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = self.coordinator
    return context
  }()

  func testInsert() {
    do {
      let user = try NSManagedObject.insert(User.self, in: context)
      user.firstName = "Chris"
      user.lastName = "Winter"
      user.willSave()
      do {
        XCTAssertTrue(user.hasChanges)
        try context.save()
        user.didSave()
        XCTAssertFalse(user.hasChanges)
      } catch {
        XCTFail("Could not save context")
      }
    } catch {
      XCTFail("Failed to created new object")
    }
  }

  func testInsertAndSave() {
    let user = try! NSManagedObject.insertAndSave(User.self, in: context) { user in
      user.firstName = "Chris"
      user.lastName = "Winter"
    }
    XCTAssertEqual(user.firstName, "Chris")
    XCTAssertEqual(user.lastName, "Winter")
    XCTAssertFalse(user.hasChanges)
  }

  func testBinding() {
    let controller = BindingsController()
    let user = try! NSManagedObject.insert(User.self, in: context)
    var firstNameLabel: UILabel? = UILabel()
    var lastNameLabel: UILabel? = UILabel()

    user.firstName = "Chris"

    controller.addBindings(
      user.bind(\.firstName, to: firstNameLabel, keyPath: \.text),
      user.bind(\.lastName, to: lastNameLabel, keyPath: \.text)
    )

    XCTAssertEqual(firstNameLabel?.text, user.firstName)
    XCTAssertEqual(lastNameLabel?.text, user.lastName)

    user.firstName = "Sindre"
    user.lastName = "Moen"
    XCTAssertEqual(firstNameLabel?.text, user.firstName)
    XCTAssertEqual(lastNameLabel?.text, user.lastName)

    firstNameLabel = nil
    lastNameLabel = nil
    user.firstName = "Eirik"
    user.lastName = "Penne"

    XCTAssertEqual(user.firstName, "Eirik")
    XCTAssertEqual(user.lastName, "Penne")
    XCTAssertEqual(firstNameLabel?.text, nil)
  }
}
