import UIKit

extension UICollectionView {
  @discardableResult
  public func reloadVisibleItems() -> UICollectionView {
    reloadItems(at: indexPathsForVisibleItems)
    return self
  }
}
