import Cocoa

extension NSCollectionView {
  @discardableResult
  public func reloadVisibleItems() -> NSCollectionView {
    reloadItems(at: indexPathsForVisibleItems())
    return self
  }
}
