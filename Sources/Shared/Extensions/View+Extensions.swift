#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension View {
  var superviews: UnfoldFirstSequence<View> {
    return sequence(first: self) { view in view.superview }
  }

  func enclosingView<T>(type: T.Type) -> T? where T: View {
    return superviews.first(where: { $0 is T }) as! T?
  }

  func enclosingView<T>(predicate: (T) -> Bool) -> T? where T: View {
    return superviews.first(where: { $0 is T }) as! T?
  }
}
