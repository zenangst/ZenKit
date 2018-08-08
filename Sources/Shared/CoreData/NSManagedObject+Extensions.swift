import CoreData
import Foundation

public extension NSManagedObject {
  public static var entity: NSEntityDescription {
    let stringSelf = String(describing: self)
    let entity = NSEntityDescription()
    entity.name = stringSelf
    entity.managedObjectClassName = stringSelf
    return entity
  }
  
  static public func insert<T: NSManagedObject>(_ type: T.Type,
                                                in context: NSManagedObjectContext) throws -> T {
    return try ManagedObjectManager.object(type, in: context) as T
  }

  @discardableResult
  static public func insertAndSave<T: NSManagedObject>(_ type: T.Type,
                                                in context: NSManagedObjectContext,
                                                closure: (T) -> Void) throws -> T {
    let object: T = try ManagedObjectManager.object(type, in: context)
    closure(object)
    object.willSave()
    try context.save()
    object.didSave()
    return object
  }
}
