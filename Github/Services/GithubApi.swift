//
//  GetRepositoriesService.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 29/03/22.
//

import Foundation
import Alamofire

protocol GithubApiRepositoriesProtocol {
    func fetchRepositories(
        from language: String,
        orderingBy: String,
        completion: @escaping (Result<GithubRepositories, NetworkingServiceError>) -> Void
    )
}

final class GithubApi: GithubApiRepositoriesProtocol {
    let profileURL = "https://api.github.com/users/"

    private let networking: NetworkingService

    init(networking: NetworkingService = NetworkingService()) {
        self.networking = networking
    }

    static var shared: GithubApi {
        let instance = GithubApi()
        return instance
    }

	func getProfile(named username: String, completion: @escaping (Result<GithubUser, NetworkingServiceError>) -> Void) {
        networking.request(url: profileURL+username, method: HTTPMethod.get, of: GithubUser.self) { response in
			switch response {
			case .success(let user):
				completion(.success(user))
			case .failure(let error):
				completion(.failure(.requestError(error.localizedDescription)))
			}
		}
	}

    func fetchRepositories(from language: String,
                           orderingBy: String,
                           completion: @escaping (Result<GithubRepositories, NetworkingServiceError>) -> Void) {
        let baseUrl = "https://api.github.com/search/repositories"
        let queryParams = "?q=stars:%3E=5000+language:\(language)&sort=stars&order=\(orderingBy)"
        let url = "\(baseUrl)\(queryParams)"
        networking.request(url: url, method: HTTPMethod.get, of: GithubRepositories.self) { response in
            switch response {
            case .success(let repositories):
                completion(.success(repositories))
            case .failure(let error):
                completion(.failure(.requestError(error.localizedDescription)))
            }
        }
    }
}
