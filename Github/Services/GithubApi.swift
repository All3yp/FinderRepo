//
//  GetRepositoriesService.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 29/03/22.
//

import Foundation


protocol GithubApiRepositoriesProtocol {
    func getRepositories(completion: @escaping(Result<GithubRepositories, NetworkingServiceError>) -> Void)
    // func getUsers()
}


final class GithubApi: GithubApiRepositoriesProtocol {

    // TODO: Apply reusability
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
        networking.request(url: url, method: "") { response in
            
            print(response)
            switch response {
            case .success(let respositories):
                print(respositories)
                completion(.success(respositories))
//            case .failure():
//                completion(.failure(.requestError))
            default:
                break
            }
            
        }
    }
}
