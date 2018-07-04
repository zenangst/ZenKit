import Foundation

private extension String {
  subscript(_ range: NSRange) -> String {
    let start = self.index(self.startIndex, offsetBy: range.lowerBound)
    let end = self.index(self.startIndex, offsetBy: range.upperBound)
    let subString = self[start..<end]
    return String(subString)
  }
}

public class ONP {
  var A: String
  var B: String
  var M: Int
  var N: Int
  var editdis: Int = 0

  public init(A: String, B: String) {
    (self.A, self.M) = (A, A.count)
    (self.B, self.N) = (B, B.count)

    if A.count > B.count {
      swap(B, A)
    }
  }

  @discardableResult
  public func compose() -> ONP {
    var (p, op, opp, oi, ly) = (-1, 0, 0, 0, 0)
    let size = M + N + 3
    let delta = N - M
    let offset = M + 1

    var fp = Array<Int>()
    fp.reserveCapacity(size)

    for _ in 0..<size {
      fp.append(-1)
    }

    repeat {
      p += 1
      var k = -p
      while k<=delta-1 {
        op = fp[k-1+offset]
        opp = fp[k+1+offset]
        oi = snake(k, p: op+1, pp: opp)
        fp[k+offset] = oi
        k += 1
      }

      k = delta+p
      while k>=delta+1 {
        op = fp[k-1+offset]
        opp = fp[k+1+offset]
        oi = snake(k, p: op+1, pp: opp)
        fp[k+offset] = oi
        k -= 1
      }

      op = fp[delta-1+offset]
      opp = fp[delta+1+offset]
      oi = snake(delta, p: op+1, pp: opp)
      fp[delta+offset] = oi
      ly = fp[delta+offset]
    } while ly < N
    editdis = delta + 2 * p
    return self
  }

  private func swap(_ A: String, _ B: String) {
    (self.A, self.M) = (B, B.count)
    (self.B, self.N) = (A, A.count)
  }

  private func snake(_ k: Int, p: Int, pp: Int) -> Int {
    var y = max(p, pp)
    var x = y - k

    while x < M &&
      y < N &&
      String(A[A.index(A.startIndex, offsetBy: x)]) == String(B[B.index(B.startIndex, offsetBy: y)]) {
        x += 1
        y += 1
    }

    return y
  }
}
