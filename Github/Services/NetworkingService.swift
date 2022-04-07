//
//  NetworkingService.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 29/03/22.
//

import Foundation
import Alamofire

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

protocol NetworkingServiceProtocol {
    func request<T: Codable>(url: String,
                             method: HTTPMethod,
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
                    method: HTTPMethod,
                    of type: T.Type,
                    completion: @escaping (Result<T,
                                           NetworkingServiceError>) -> Void) where T: Decodable, T: Encodable {
        AF.request(url, method: .get).validate().responseDecodable(of: T.self) { response in

            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(.requestError(error.localizedDescription)))
            }
        }
    }
}
