import RxSwift
import RxRelay
import Foundation

@testable import GithubAPIFluxUnio

final class MockRepositoryStore: RepositoriesStoreType{
    var error: Observable<Error>{
        return _error.asObservable()
    }
    
    var repositories: Observable<[Repository]> {
        return _repositories.asObservable()
    }

    let _error = BehaviorRelay<Error>(value: NSError())
    let _repositories = BehaviorRelay<[Repository]>(value: [])
}
