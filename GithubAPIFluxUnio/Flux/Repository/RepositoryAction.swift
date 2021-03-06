//
//  Action.swift
//  GithubAPIFluxUnio
//
//  Created by 松山響也 on 2022/04/27.
//

import Foundation
import RxSwift

protocol RepositoryActionType{
    func searchRepositories(keyword:String)->Observable<Void>
}


final class RepositoryAction:RepositoryActionType{
    static let shared = RepositoryAction()
    
    init(apiClient:ApiClientInterface = ApiClient.shared,
         dispatcher:RepositoryDispatcher = .shared){
        self.apiClient = apiClient
        self.dispatcher = dispatcher
    }
    
    func searchRepositories(keyword:String)->Observable<Void>{
        apiClient.request(RepositoryTargetType(keyword: keyword)).subscribe {[weak self] repositories in
            self?.dispatcher.updateRepositories.dispatch(repositories.items)
        } onError: {[weak self] error in
            self?.dispatcher.error.dispatch(error)
        }.disposed(by: disposeBag)
        
        return Observable.just(())
    }
    
    private let apiClient: ApiClientInterface
    
    private let dispatcher: RepositoryDispatcher
    
    private let disposeBag = DisposeBag()
}
