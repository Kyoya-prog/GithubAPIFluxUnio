import Foundation
import Moya
import RxSwift

protocol ApiClientInterface {
    func request<T:ApiTargetType>(_ request:T)->Single<T.Response>
}

class ApiClient: ApiClientInterface {
    private init() {}

    static let shared = ApiClient()

    func request<T:ApiTargetType>(_ request:T)->Single<T.Response>{
        return Single<T.Response>.create { observer in
            let provider = MoyaProvider<T>()
            provider.request(request) { result in
                switch result {
                case let .success(response):
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(T.Response.self, from: response.data)
                        observer(.success(model))
                    } catch {
                        observer(.failure(error))
                    }

                case let .failure(error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
