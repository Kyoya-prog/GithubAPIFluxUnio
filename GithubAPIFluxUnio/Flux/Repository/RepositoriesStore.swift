import RxRelay
import RxSwift
import Foundation

protocol RepositoriesStoreType{
    var repositories:Observable<[Repository]> {get}
    var error:Observable<Error>{get}
}

final class RepositoriesStore:RepositoriesStoreType{
    static let shared = RepositoriesStore()
    
    @BehaviorWrapper(value: [])
    var repositories:Observable<[Repository]>
    @BehaviorWrapper(value: NSError())
    var error:Observable<Error>
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher:RepositoryDispatcher = .shared){
        dispatcher
            .updateRepositories
            .bind(to: _repositories)
            .disposed(by: disposeBag)
        
        dispatcher
            .error
            .bind(to: _error)
            .disposed(by: disposeBag)
    }
}


