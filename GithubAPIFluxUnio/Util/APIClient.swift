import Foundation
import Moya
import RxSwift

protocol ApiClientInterface {
    func request<T:ApiTargetType>(_ request:T)->Observable<T.Response>
}

class ApiClient: ApiClientInterface {
    private init() {}

    static let shared = ApiClient()

    func request<T:ApiTargetType>(_ request:T)->Observable<T.Response>{
        return Observable.create { observer in
            let provider = MoyaProvider<T>()
            provider.request(request) { result in
                switch result {
                case let .success(response):
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(T.Response.self, from: response.data)
                        observer.onNext(model)
                    } catch {
                        observer.onError(error)
                    }

                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
