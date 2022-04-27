import RxRelay
import RxSwift

final class RepositoriesStore{
    static let shared = RepositoriesStore()
    
    let repositories = BehaviorRelay<[Repository]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private init(dispatcher:RepositoryDispatcher = .shared){
        dispatcher.updateRepositories.bind(to: repositories).disposed(by: disposeBag)
    }
}


