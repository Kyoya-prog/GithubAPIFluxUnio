import RxSwift
import RxRelay
import Unio

protocol RepositoryViewStreamProtocol: AnyObject{
    var input:InputWrapper<RepositoryViewStream.Input> {get}
    var output:OutputWrapper<RepositoryViewStream.Output>{get}
}

final class RepositoryViewStream:UnioStream<RepositoryViewStream>,RepositoryViewStreamProtocol{
    convenience init(flux: Flux = .shared) {
        self.init(input: Input(),
                  state: State(),
                  extra: Extra(flux: flux))
    }
}

extension RepositoryViewStream{
    struct Input: InputType{
        let search = PublishRelay<String>()
    }
    
    struct Output: OutputType{
        let searchedRepositories: BehaviorRelay<[Repository]>
        let errorOccured: PublishSubject<String>
    }
    
    struct State: StateType{
        let repositories = BehaviorRelay<[Repository]>(value: [])
    }
    
    struct Extra: ExtraType{
        let flux:Flux
    }
}

extension RepositoryViewStream{
    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {
        let state = dependency.state
        let extra = dependency.extra
        let flux = extra.flux

        let searchRepositories = dependency.inputObservables.search
        searchRepositories.subscribe { keyword in
            flux.repositoryAction.searchRepositories(keyword: keyword)
        }.disposed(by: disposeBag)
        
        let errorSubject = PublishSubject<String>()
        
        flux.repositoryStore.repositories.subscribe { repositories in
            state.repositories.accept(repositories)
        } onError: { error in
            errorSubject.onNext(error.localizedDescription)
        }.disposed(by: disposeBag)

        
        return Output(searchedRepositories: state.repositories, errorOccured: errorSubject)
    }
}
