//
//  GetRepositoriesService.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 29/03/22.
//

import Foundation

protocol GithubApiRepositoriesProtocol {
    func getRepositories(completion: @escaping(Result<GithubRepositories, NetworkingServiceError>) -> Void)
    func getRepositoriesfrom(language: String,
                             orderingBy: String,
                             completion: @escaping (Result<GithubRepositories, NetworkingServiceError>) -> Void)
    // func getUsers()
}

final class GithubApi: GithubApiRepositoriesProtocol {
    let url = "https://api.github.com/search/repositories?q=stars:%3E=10000+language:swift&sort=stars&order=desc"

    private let networking: NetworkingService

    init(networking: NetworkingService = NetworkingService()) {
        self.networking = networking
    }

    static var shared: GithubApi {
        let instance = GithubApi()
        return instance
    }

    func getRepositories(completion: @escaping (Result<GithubRepositories, NetworkingServiceError>) -> Void) {
        networking.request(url: url, method: "", of: GithubRepositories.self) { response in

            switch response {
            case .success(let respositories):
                completion(.success(respositories))
            case .failure(let error):
                completion(.failure(.requestError(error.localizedDescription)))
            }
        }
    }

    func getRepositoriesfrom(language: String,
                             orderingBy: String,
                             completion: @escaping (Result<GithubRepositories, NetworkingServiceError>) -> Void) {
        let baseUrl = "https://api.github.com/search/repositories"
        let queryParams = "?q=stars:%3E=5000+language:\(language)&sort=stars&order=\(orderingBy)"
        let url = "\(baseUrl)\(queryParams)"
        networking.request(url: url, method: "", of: GithubRepositories.self) { response in
            switch response {
            case .success(let repositories):
                completion(.success(repositories))
            case .failure(let error):
                completion(.failure(.requestError(error.localizedDescription)))
            }
        }
    }
}
