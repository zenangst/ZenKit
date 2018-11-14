import UIKit

open class TableViewController: UITableViewController {
  let cells: [UITableViewCell.Type]
  let dataSource: UITableViewDataSource
  let configuration: (UITableView) -> Void

  public init(cells: [UITableViewCell.Type],
              dataSource: UITableViewDataSource,
              configuration: @escaping (UITableView) -> Void) {
    self.cells = cells
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
    cells.forEach {
      tableView.register($0, forCellReuseIdentifier: String(describing: $0))
    }
    configuration(tableView)
    tableView.dataSource = dataSource
  }
}
