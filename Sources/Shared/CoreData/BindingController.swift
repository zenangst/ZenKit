import CoreData
import Foundation

public class BindingsController {
  var bindings = [NSKeyValueObservation]()

  public init() {}
  public func addBindings(_ bindings: NSKeyValueObservation ...) {
    self.bindings.append(contentsOf: bindings)
  }
}
