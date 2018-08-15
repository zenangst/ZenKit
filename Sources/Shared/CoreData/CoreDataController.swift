import CoreData
import Foundation

public protocol CoreDataController {
  var context: NSManagedObjectContext { get }
}

public extension CoreDataController {
  func parse<T: NSManagedObject>(_ notification: Notification,
                                 for type: T.Type,
                                 updateClosure: ([T]) -> Void) {
    guard notification.objectIsEqualContext(context),
      let userInfo = notification.userInfo else {
        return
    }

    let (updates, inserts, deletes) = (
      userInfo[NSUpdatedObjectsKey] as? Set<T> ?? [],
      userInfo[NSInsertedObjectsKey] as? Set<T> ?? [],
      userInfo[NSDeletedObjectsKey] as? Set<T> ?? []
    )

    let updatedObjects: [T] = updates.filter({ !$0.changedValues().isEmpty })

    if !updatedObjects.isEmpty || !inserts.isEmpty || !deletes.isEmpty {
      updateClosure(updatedObjects)
    }
  }

  func fetch<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]) throws -> [T] {
    do {
      let result: [T] = try context.fetch(T.self, sortDescriptors: sortDescriptors)
      return result
    }
  }
}

fileprivate extension Notification {
  func objectIsEqualContext(_ context: NSManagedObjectContext) -> Bool {
    return object as? NSManagedObjectContext == context
  }
}
