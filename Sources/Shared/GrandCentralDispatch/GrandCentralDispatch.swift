import Foundation

public enum Queue {
  case main, userInteractive, userInitiated, background, custom(DispatchQueue)
  var dq: DispatchQueue {
    let result: DispatchQueue
    switch self {
    case .main: result = .main
    case .userInteractive: result = .global(qos: .userInteractive)
    case .userInitiated: result = .global(qos: .userInitiated)
    case .background: result = .global(qos: .utility)
    case .custom(let queue): return queue
    }
    return result
  }
}

private class Reference<T> {
  var value: T?
}

public typealias GrandCentral = Dispatch<Void>

public class Dispatch<Out> {
  private let item: DispatchWorkItem
  private let _output: Reference<Out>
  public var output: Out? { return _output.value }

  fileprivate init(_ item: DispatchWorkItem,
                   output: Reference<Out> = Reference()) {
    self.item = item
    self._output = output
  }

  static private func _dispatch<O>(queue: DispatchQueue = .main,
                                   _ block: @escaping () -> O) -> Dispatch<O> {
    let group = DispatchGroup()
    let reference = Reference<O>()
    let item = DispatchWorkItem { reference.value = block() }
    queue.async(group: group, execute: item)
    return Dispatch<O>(item, output: reference)
  }

  private func _dispatch<O>(queue: DispatchQueue = .main,
                            _ block: @escaping (Out) -> O) -> Dispatch<O> {
    let reference = Reference<O>()
    let item = DispatchWorkItem { reference.value = block(self.output!) }
    self.item.notify(queue: queue, execute: item)
    return Dispatch<O>(item, output: reference)
  }

  // MARK: - Public API

  @discardableResult
  public static func dispatch<O>(_ queue: Queue, _ block: @escaping () -> O) -> Dispatch<O> {
    return GrandCentral._dispatch(queue: queue.dq, block)
  }

  @discardableResult
  public func dispatch<O>(_ queue: Queue, _ block: @escaping (Out) -> O) -> Dispatch<O> {
    return _dispatch(queue: queue.dq, block)
  }
}
