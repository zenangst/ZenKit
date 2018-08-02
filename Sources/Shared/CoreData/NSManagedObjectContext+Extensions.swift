import CoreData
import Foundation

public extension NSManagedObjectContext {
  public func fetch<T: NSManagedObject>(_ type: T.Type,
                                        closure: ((NSFetchRequest<T>) -> Void)? = nil,
                                        predicates: NSPredicate ...) throws -> [T] {
    let request = NSFetchRequest<T>(type, predicates: predicates)
    closure?(request)
    return try self.fetch(request)
  }
}

public extension NSFetchRequest {
  @objc public convenience init(_ type: NSManagedObject.Type,
                                predicates: [NSPredicate] = []) {
    self.init(entityName: ManagedObjectManager.entityName(for: type))
  }
}
