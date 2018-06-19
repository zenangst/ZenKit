import Foundation

public enum Result<T, U> {
  case success(T)
  case failure(U)
}

