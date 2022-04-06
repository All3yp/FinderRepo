//
//  NetworkingService.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 29/03/22.
//

import Foundation
import Alamofire

// MARK: Create enum GetRepositoriesServiceError: NetworkingServiceError
// Inherit from LocalizedError
enum NetworkingServiceError: LocalizedError {
    case urlInvalid
    case requestError(_ description: String)
    case noDataAvailable

    var localizedError: String {
        switch self {
        case .urlInvalid:
            return "urlInvalid"
        case .requestError(description: let description):
            return "Error on Request: \(description)"
        case .noDataAvailable:
            return "No Data Available"
        }
    }
}

protocol AppBaseModel: Codable {

}

protocol AppBaseEndpoint {
    /*
     urlPath
     query
     queryParams: language, stars, ascd/desc
     method
     headers
     */
}

protocol DeprecatedNetworkingServiceProtocol {
    func request(url: String,
                 method: String,
                 completion: @escaping(Result<GithubRepositories, NetworkingServiceError>) -> Void)
}

protocol NetworkingServiceProtocol {
    func request<T: Codable>(url: String,
                             method: String,
                             of type: T.Type,
                             completion: @escaping(Result<T, NetworkingServiceError>) -> Void)
}

final class NetworkingService: NetworkingServiceProtocol {

    private func urlBuilder(urlPath: String) -> URL? {
        guard let urlPathQueryEncoding = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlPathQueryEncoding) else {
                  return nil
              }
        return url
    }

    func request<T>(url: String,
                    method: String,
                    of type: T.Type,
                    completion: @escaping (Result<T,
                                           NetworkingServiceError>) -> Void) where T: Decodable, T: Encodable {
        AF.request(url, method: .get).validate().responseDecodable(of: T.self) { response in

            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
					print(error)
                completion(.failure(.requestError(error.localizedDescription)))
            }
        }
    }
}

final class DeprecatedNetworkingService: DeprecatedNetworkingServiceProtocol {
    func request(url: String,
                 method: String,
                 completion: @escaping (Result<GithubRepositories, NetworkingServiceError>) -> Void) {
//        guard let url = urlBuilder(urlPath: url) else {
//            completion(.failure(.urlInvalid))
//            return
//        }
        AF.request(url, method: .get).validate().responseDecodable(of: GithubRepositories.self) { response in
            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(.requestError(error.localizedDescription)))
            }
        }
    }
}
