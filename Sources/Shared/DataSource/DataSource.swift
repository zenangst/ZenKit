import Foundation

open class DataSource: NSObject, DataSourceDriven {
  weak var view: Reloadable?

  override init() {
    super.init()
    Injection.add(observer: self, with: #selector(injected(_:)))
  }

  @objc open func injected(_ notification: Notification) {
    guard Injection.objectWasInjected(self, in: notification) else { return }
    view?.reloadData()
  }
}
