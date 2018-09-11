import Foundation

open class DataSource: NSObject, DataSourceDriven {
  public weak var view: Reloadable?
}
