import UIKit

open class TableViewController: UITableViewController {
  let dataSource: UITableViewDataSource
  let configuration: (UITableView) -> Void

  public init(dataSource: UITableViewDataSource,
       configuration: @escaping (UITableView) -> Void) {
    self.dataSource = dataSource
    self.configuration = configuration
    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View lifecycle

  override open func viewDidLoad() {
    super.viewDidLoad()
    configuration(tableView)
    tableView.dataSource = dataSource
  }
}
