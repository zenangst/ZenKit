import XCTest
import CoreData
import ZenKit

@objc(User)
class User: NSManagedObject {
  var firstName: String?
  var lastName: String?
}

class CoreDataTests: XCTestCase {
  func testCoreData() {
    let model = NSManagedObjectModel()
    model.entities = [User.entity]

    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    _ = try? coordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                        configurationName: nil,
                                        at: nil,
                                        options: nil)
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = coordinator

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
}
