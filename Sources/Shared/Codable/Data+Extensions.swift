import Foundation

public extension Data {
  func decode<T: Decodable>(to: T, with decoder: JSONDecoder = .init()) -> Result<T, Error> {
    do {
      let object: T = try decoder.decode(T.self, from: self)
      return .success(object)
    } catch let error {
      return .failure(error)
    }
  }

  func encode<T: Encodable>(from object: T, with encoder: JSONEncoder = .init()) -> Result<Data, Error> {
    do {
      let data = try encoder.encode(object)
      return .success(data)
    } catch let error {
      return .failure(error)
    }
  }
}
