import RxRelay
import RxSwift
import ObjectiveC

typealias Repository = SearchRepositoryEntity.Item

protocol RepositoriesStoreType{
    var repositories:BehaviorRelay<[Repository]> {get}
    var error:PublishRelay<Error>{get}
}

final class RepositoriesStore:RepositoriesStoreType{
    static let shared = RepositoriesStore()
    
    var repositories = BehaviorRelay<[Repository]>(value: [])
    var error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher:RepositoryDispatcher = .shared){
        dispatcher.updateRepositories.subscribe {[weak self] result in
            guard let items = result.element?.items else {
                self?.repositories.accept([])
                return
            }
            self?.repositories.accept(items)
        }.disposed(by: disposeBag)
        
        dispatcher.error.bind(to: error).disposed(by: disposeBag)
    }
}


