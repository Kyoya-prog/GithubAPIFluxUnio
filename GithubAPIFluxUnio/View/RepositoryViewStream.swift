import RxSwift
import RxRelay
import Unio
import Action

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
        let repositories: BehaviorRelay<[Repository]>
        let errorOccured: PublishRelay<String>
    }
    
    struct State: StateType{
        let repositories = BehaviorRelay<[Repository]>(value: [])
    }
    
    struct Extra: ExtraType{
        let flux:Flux
        let searchKeywordAction: Action<String,Void>
    }
}

extension RepositoryViewStream{
    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {
        let state = dependency.state
        let extra = dependency.extra
        let flux = extra.flux
        
        let searchRepositories = dependency.inputObservables.search
        
        searchRepositories.bind(to: extra.searchKeywordAction.inputs)
            .disposed(by: disposeBag)
        
        let errorRelay = PublishRelay<String>()
        
        flux.repositoryStore
            .error
            .subscribe { event in
                guard let error = event.element else { return }
                let message = ErrorMessageBuilder.buildErrorMessage(error: error, message: "リポジトリ検索")
                errorRelay.accept(message)
            }.disposed(by: disposeBag)
        
        flux.repositoryStore
            .repositories
            .bind(to: state.repositories)
            .disposed(by: disposeBag)
        
        return Output(repositories: state.repositories, errorOccured: errorRelay)
    }
}

extension RepositoryViewStream.Extra {
    init(flux:Flux){
        self.flux = flux
        
        let repositoryAction = flux.repositoryAction
        
        self.searchKeywordAction = Action{ keyword in
            repositoryAction.searchRepositories(keyword: keyword)
        }
    }
}
