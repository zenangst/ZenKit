import UIKit

open class CollectionViewDataSource<T: Hashable>: DataSource, UICollectionViewDataSource {
  let configuration: (UICollectionView, T, IndexPath) -> UICollectionViewCell
  var collectionView: UICollectionView? { return view as? UICollectionView }
  var models: [T]

  required public init(models: [T] = [], configuration: @escaping (UICollectionView, T, IndexPath) -> UICollectionViewCell) {
    self.models = models
    self.configuration = configuration
    super.init()
  }

  public func model(at indexPath: IndexPath) -> T {
    return models[indexPath.item]
  }

  public func indexPath(for model: T) -> IndexPath? {
    guard let index = models.index(of: model) else { return nil }
    return IndexPath(item: index, section: 0)
  }

  public func indexPaths(for models: [T]) -> [IndexPath] {
    let filteredModels = self.models.filter({ models.contains($0) })
    var indexPaths = [IndexPath]()
    for model in filteredModels {
      guard let indexPath = indexPath(for: model) else { continue }
      indexPaths.append(indexPath)
    }
    return indexPaths
  }

  public func reload(with models: [T], completion: ((UICollectionView) -> Void)? = nil) {
    guard let collectionView = collectionView else { return }
    let manager = DiffManager()
    let changes = manager.diff(self.models, models)
    collectionView.reload(with: changes,
                          updateDataSource: { self.models = models },
                          completion: { completion?(collectionView) })
  }

  public func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
    return models.count
  }

  public func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return configuration(collectionView, model(at: indexPath), indexPath)
  }
}
