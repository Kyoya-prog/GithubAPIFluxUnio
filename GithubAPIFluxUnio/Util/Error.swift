import Alamofire
import Foundation
import Moya

enum APIError: Error {
    case connectionError
    case serverError
    case unknownError(_ error: Error)
    case networkError
    case badRequestError

    var message: String {
        switch self {
        case .connectionError:
            return "サーバーとの接続に失敗しました。"

        case .serverError:
            return "サーバーでエラーが発生しました。"

        case .unknownError:
            return "予期せぬエラーが発生しました。"

        case .networkError:
            return "通信エラーが発生しました。"

        case .badRequestError:
            return "不正なリクエストです。"
        }
    }
}

class ErrorMessageBuilder {
    static func buildErrorMessage(error: Error, message: String) -> String {
        if let error = (error as? MoyaError) {
            let apiError = checkMoyaError(error: error)
            return message + "(\(apiError.message))"
        }

        return message
    }

    private static func checkMoyaError(error: MoyaError) -> APIError {
        if let error = ((error.errorUserInfo["NSUnderlyingError"]as? Alamofire.AFError)?.underlyingError as NSError?) {
            switch error.code {
            case -1004:
                return .connectionError

            case -1009:
                return .networkError

            default:
                return .unknownError(error)
            }
        } else {
            switch error {
            case .objectMapping(_, _):
                return .badRequestError

            case .statusCode(_):
                return .serverError

            default:
                return .unknownError(error)
            }
        }
    }
}
