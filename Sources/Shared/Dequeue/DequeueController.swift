import CoreGraphics
import Foundation

public class DequeueController: NSObject {
  private var viewCache: NSCache = NSCache<NSString, View>()
  private var controllerCache: NSCache = NSCache<NSString, Controller>()
  private var controllers = [String: Controller.Type]()
  private var views = [String: View.Type]()

  public func purge() {
    viewCache.removeAllObjects()
    controllerCache.removeAllObjects()
  }

  public func register(_ view: View.Type, with identifier: DequeueStringIdentifier) {
    self.views[identifier.string] = view
  }

  public func register(_ controller: Controller.Type, with identifier: DequeueStringIdentifier) {
    self.controllers[identifier.string] = controller
  }

  public func dequeueView(withIdentifier identifier: DequeueStringIdentifier,
                          frame: CGRect = .zero,
                          _ closure: ((View.Type) -> View)? = nil) throws -> View {
    let type = try resolveViewType(with: identifier)
    return dequeueView(of: type, frame: frame, closure)
  }

  @discardableResult
  public func prepare<T: View>(types: T.Type ...) {
    let container = View()
    for type in types {
      let dequeuedView = dequeueView(of: type, frame: .init(origin: .zero, size: .init(width: 50, height: 50)))
      container.addSubview(dequeuedView)
    }
    container.subviews.forEach { $0.removeFromSuperview() }
  }

  @discardableResult
  public func dequeueView<T: View>(of type: T.Type,
                          frame: CGRect = .zero,
                          _ closure: ((T.Type) -> T)? = nil) -> T
  {
    var offset = 0
    var identifier = "\(type)-\(offset)"
    var dequeuingDone = false
    var cachedView: T?

    while !dequeuingDone {
      _dequeueView(&identifier, &cachedView, &dequeuingDone, type, &offset)
    }

    if let cachedView = cachedView {
      return cachedView
    }

    let view: T
    if let closure = closure {
      view = closure(type)
    } else {
      view = type.init(frame: frame)
    }

    viewCache.setObject(view, forKey: identifier as NSString)
    return view
  }

  public func dequeueController(withIdentifier identifier: DequeueStringIdentifier,
                                frame: CGRect = .zero,
                                _ closure: ((Controller.Type) -> Controller)? = nil) throws -> Controller {
    let type = try resolveControllerType(with: identifier)
    return dequeueController(of: type, frame: frame, closure)
  }

  public func dequeueController(of type: Controller.Type,
                                frame: CGRect = .zero,
                                _ closure: ((Controller.Type) -> Controller)? = nil) -> Controller
  {
    var offset = 0
    var identifier = "\(type)"
    var dequeuingDone = false
    var cachedController: Controller?

    while !dequeuingDone {
      dequeueController(&identifier, &cachedController, &dequeuingDone, type, &offset)
    }

    if let cachedController = cachedController {
      return cachedController
    }

    let controller: Controller
    if let closure = closure {
      controller = closure(type)
    } else {
      controller = type.init()
    }

    controllerCache.setObject(controller, forKey: identifier as NSString)
    return controller
  }

  private func _dequeueView<T: View>(_ identifier: inout String, _ cachedView: inout T?, _ dequeuingDone: inout Bool, _ type: T.Type, _ offset: inout Int) {
    if let view = viewCache.object(forKey: identifier as NSString) as? T {
      if view.superview == nil {
        cachedView = view
        dequeuingDone = view.superview == nil
      }
      offset += 1
      identifier = "\(type)-\(offset)"
    } else {
      dequeuingDone = true
    }
  }

  private func dequeueController<T: Controller>(_ identifier: inout String, _ cachedController: inout T?, _ dequeuingDone: inout Bool, _ type: T.Type, _ offset: inout Int) {
    if let controller = controllerCache.object(forKey: identifier as NSString) as? T {
      if controller.parent == nil {
        cachedController = controller
        dequeuingDone = controller.parent == nil
      }
      identifier = "\(type)-\(offset)"
      offset += 1
    } else {
      dequeuingDone = true
    }
  }

  private func resolveViewType(with identifier: DequeueStringIdentifier) throws -> View.Type {
    guard let view = views[identifier.string] else {
      throw DequeueError.unableToResolveType
    }

    return view
  }

  private func resolveControllerType(with identifier: DequeueStringIdentifier) throws -> Controller.Type {
    guard let controller = controllers[identifier.string] else {
      throw DequeueError.unableToResolveType
    }

    return controller
  }
}
