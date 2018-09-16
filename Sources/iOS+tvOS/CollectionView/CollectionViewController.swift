import UIKit

open class CollectionViewController: UICollectionViewController {
  let cells: [UICollectionViewCell.Type]
  let dataSource: UICollectionViewDataSource
  let configuration: (UICollectionView) -> Void

  public init(cells: [UICollectionViewCell.Type],
              layout: UICollectionViewLayout,
              dataSource: UICollectionViewDataSource,
              configuration: @escaping (UICollectionView) -> Void) {
    self.cells = cells
    self.dataSource = dataSource
    self.configuration = configuration
    super.init(collectionViewLayout: layout)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View lifecycle

  override open func viewDidLoad() {
    super.viewDidLoad()
    guard let collectionView = collectionView else { return }
    cells.forEach {
      collectionView.register($0, forCellWithReuseIdentifier: String(describing: $0))
    }
    configuration(collectionView)
    collectionView.dataSource = dataSource
  }
}
