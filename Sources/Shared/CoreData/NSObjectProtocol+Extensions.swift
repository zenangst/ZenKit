import CoreData
import Foundation

public extension NSObjectProtocol where Self: NSObject {
  public func bind<Value, T: NSObject>(_ observedKeyPath: KeyPath<Self, Value>,
                          to target: T?,
                          keyPath: ReferenceWritableKeyPath<T, Value>) -> NSKeyValueObservation
  {
    let options: NSKeyValueObservingOptions = [.initial, .new]
    let observation = observe(observedKeyPath, options: options) { _, change in
      guard let newValue = change.newValue else { return }
      target?[keyPath: keyPath] = newValue
    }
    return observation
  }
}
