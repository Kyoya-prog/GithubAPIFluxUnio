import Foundation

final class RepositoryDispatcher{
    static let shared = RepositoryDispatcher()
    
    let updateRepositories = DispatchRelay<SearchRepositoryEntity>()
    
    let error = DispatchRelay<Error>()
}
