import UIKit

open class CollectionViewController: UICollectionViewController {
  let dataSource: UICollectionViewDataSource
  let configuration: (UICollectionView) -> Void

  init(layout: UICollectionViewLayout,
       dataSource: UICollectionViewDataSource,
       configuration: @escaping (UICollectionView) -> Void) {
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
    configuration(collectionView)
    collectionView.dataSource = dataSource
  }
}
