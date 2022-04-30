import RxSwift
import RxRelay

@testable import GithubAPIFluxUnio

final class MockAPIClient<T:ApiTargetType>: ApiClientInterface{
    func request<T>(_ request: T) -> Observable<T.Response> where T : ApiTargetType {
        return _result.dematerialize() as! Observable<T.Response>
    }
    
    let _result = PublishRelay<Event<T.Response>>()
}
