import Moya
import Foundation
///　デフォルト実装を用意し、レスポンスの型を定義できるようにしたTargetType
protocol ApiTargetType: TargetType {
    associatedtype Response: Decodable
}

extension ApiTargetType {
    //swiftlint:disable:next force_unwrapping
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var headers: [String: String]? {
        return  ["Content-Type": "application/json","Accept": "application/vnd.github.v3+json"]
    }
}

