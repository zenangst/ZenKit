import UIKit

public class TableViewDataSource<T: Hashable>: DataSource, UITableViewDataSource {
  let configuration: (UITableView, T, IndexPath) -> UITableViewCell
  var tableView: UITableView? { return view as? UITableView }
  var models: [T]

  required init(models: [T] = [], configuration: @escaping (UITableView, T, IndexPath) -> UITableViewCell) {
    self.models = models
    self.configuration = configuration
    super.init()
  }

  public func reload(with models: [T], completion: ((UITableView) -> Void)? = nil) {
    guard let tableView = tableView else { return }
    let manager = DiffManager()
    let changes = manager.diff(self.models, models)
    tableView.reload(with: changes,
                     updateDataSource: { self.models = models },
                     completion: { completion?(tableView) })
  }

  public func model(at indexPath: IndexPath) -> T {
    return models[indexPath.item]
  }

  public func indexPath(for model: T) -> IndexPath? {
    guard let index = models.index(of: model) else { return nil }
    return IndexPath(item: index, section: 0)
  }

  public func indexPaths(for models: [T]) -> [IndexPath] {
    let filteredPlayers = self.models.filter({ models.contains($0) })
    var indexPaths = [IndexPath]()
    for player in filteredPlayers {
      guard let indexPath = indexPath(for: player) else { continue }
      indexPaths.append(indexPath)
    }
    return indexPaths
  }

  // MARK: - UITableViewDataSource

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return configuration(tableView, model(at: indexPath), indexPath)
  }
}
