import RxSwift
import RxRelay

@testable import GithubAPIFluxUnio

final class MockRepositoryAction: RepositoryActionType {
    private(set) var isLoadCalled: Bool = false
    func load() {
        isLoadCalled = true
    }
    
    let _fetchResult = PublishRelay<Event<Void>>()

    func searchRepositories(keyword:String) -> Observable<Void> {
        return _fetchResult.dematerialize()
    }
}
