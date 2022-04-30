@testable import GithubAPIFluxUnio

extension Repository {
    static func mock() -> Repository {
        return Repository(name: "mock-repo",
                          description: "mock repository",
                          language: "mock-language",
                          owner: .mock())
    }
}

extension Repository.Owner {
    static func mock() -> Repository.Owner {
        return Repository.Owner(login: "mockowner")
    }
}
