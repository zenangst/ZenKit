import Foundation

public protocol Reloadable: class {
  func reloadData()
}

extension TableView: Reloadable {}
extension CollectionView: Reloadable {}
