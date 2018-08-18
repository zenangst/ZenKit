import Foundation

public class OperationController<T: Operation> {
  public typealias OperationManagerCompletion = (() -> Void)?
  private let _operationQueue: OperationQueue
  private var _operations = [T]()

  public init(operationQueue: OperationQueue = .init(maxConcurrentOperationCount: 1) ) {
    self._operationQueue = operationQueue
  }

  @discardableResult
  public func add(_ operations: T ...) -> OperationController {
    _operations.append(contentsOf: operations)
    return self
  }

  public func execute(_ completion: OperationManagerCompletion = nil) {
    if _operations.isNotEmpty {
      _operations.last?.completionBlock = DispatchQueue.main.wrap(completion)
      execute(_operations)
    } else {
      DispatchQueue.main.execute(completion)
    }
  }

  public func execute(_ operations: [T], waitUntilFinished: Bool = false) {
    _operationQueue.addOperations(operations, waitUntilFinished: waitUntilFinished)
    _operations.removeAll()
  }

  public func execute(waitUntilFinished: Bool = false, _ operations: T ...) {
    execute(operations, waitUntilFinished: waitUntilFinished)
  }
}
