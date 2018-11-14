import Foundation

public extension DispatchQueue {
  public typealias Closure = (() -> Void)

  public func execute(_ closure: Closure? = nil) {
    wrap(closure)()
  }

  public func wrap(_ closure: Closure? = nil) -> Closure {
    return { self.async { closure?() } }
  }
}
