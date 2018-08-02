import CoreData
import Foundation

class ManagedObjectManager {
  static func entityName(for type: NSManagedObject.Type) -> String {
    #if os(macOS)
    if #available(OSX 10.12, *) {
      return type.entity().name!
    } else {
      // This should be fixed by properly resolving the entity name on older versions of macOS.
      return String(describing: type)
    }
    #else
    return type.entity().name!
    #endif
  }
  
  static func entity(using type: NSManagedObject.Type,
                     in context: NSManagedObjectContext) -> NSEntityDescription? {
    let entityDescription = NSEntityDescription.entity(forEntityName: ManagedObjectManager.entityName(for: type),
                                                       in: context)
    return entityDescription
  }
  
  static func object<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext) throws -> T {
    guard let entity = entity(using: type, in: context) else {
      throw ManagedObjectManagerError.unableToCreateEntity
    }
    
    let managedObject = NSManagedObject(entity: entity, insertInto: context)
    guard let object = managedObject as? T else {
      throw ManagedObjectManagerError.unableToCast
    }
    
    return object
  }
}
