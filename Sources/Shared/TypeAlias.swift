#if os(macOS)
import Cocoa
public typealias Controller = NSCollectionViewItem
public typealias View = NSView
public typealias TableView = NSTableView
public typealias CollectionView = NSCollectionView
public typealias ViewController = NSViewController
#else
import UIKit
public typealias Controller = UIViewController
public typealias View = UIView
public typealias TableView = UITableView
public typealias CollectionView = UICollectionView
public typealias ViewController = UIViewController
#endif
