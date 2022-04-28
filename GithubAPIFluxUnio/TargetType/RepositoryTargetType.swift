import Foundation
import Moya

struct RepositoryTargetType: ApiTargetType {
    typealias Response = SearchRepositoryEntity

    let keyword:String

    var path: String { "/search/repositories" }

    var method: Moya.Method { .get }

    var sampleData: Data { Data() }

    var task: Task { .requestParameters(parameters: ["q":keyword], encoding: URLEncoding.queryString) }
}

struct SearchRepositoryEntity:Decodable {
    let items:[Item]
    
    struct Item:Decodable{
        let name:String
        let description:String?
        let language:String?
        let owner:Owner
        
        struct Owner:Decodable {
            let login:String
        }
    }
}
