struct Flux {
    static let shared = Flux()

    let repositoryStore: RepositoriesStoreType
    let repositoryAction: RepositoryActionType

    init(repositoryStore: RepositoriesStoreType = RepositoriesStore.shared,
         repositoryAction: RepositoryActionType = RepositoryAction.shared) {
        self.repositoryStore = repositoryStore
        self.repositoryAction = repositoryAction
    }
}
