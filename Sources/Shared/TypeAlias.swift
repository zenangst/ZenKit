#if os(macOS)
import Cocoa
public typealias Controller = NSCollectionViewItem
public typealias View = NSView
#else
import UIKit
public typealias Controller = UIViewController
public typealias View = UIView
#endif
