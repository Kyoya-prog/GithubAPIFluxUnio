import Foundation

final class RepositoryDispatcher{
    static let shared = RepositoryDispatcher()
    
    let updateRepositories = DispatchRelay<[Repository]>()
    
    let error = DispatchRelay<Error>()
    
    private init(){}
}
