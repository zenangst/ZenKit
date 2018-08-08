import CoreData
import Foundation

class ManagedObjectManager {
  static func entityName(for type: NSManagedObject.Type) -> String {
    #if os(macOS)
      if #available(OSX 10.12, *) {
        return type.entity().name!
      } else {
        return entityFallback(for: type)
      }
    #else
      if #available(iOS 10.0, *) {
        return type.entity().name!
      } else {
        return entityFallback(for: type)
      }
    #endif
  }

  static func entityFallback(for type: NSManagedObject.Type) -> String {
    return String(describing: type)
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
