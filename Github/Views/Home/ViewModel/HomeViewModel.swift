//
//  HomeViewModel.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 05/04/22.
//

import Foundation

class HomeViewModel {

    let defaultLanguage = "swift"
    var repositories: GithubRepositories?
    weak var delegate: HomeViewDelegate?

    func fetchRepositories(from language: String?, orderingBy: String) {
        GithubApi.shared.fetchRepositories(
            from: language ?? defaultLanguage,
            orderingBy: orderingBy
        ) { response in
            switch response {
            case .success(let repositories):
                self.didFetchRepositories(repositories)
            case .failure(let error):
                self.error(error)
            }
        }
    }

    private func didFetchRepositories(_ repositories: GithubRepositories) {
        self.repositories = repositories
        delegate?.didUpdateRepositories()
    }

    private func error(_ error: NetworkingServiceError) {
        let errorAlert = AppTheme.buildActionAllertDefault(
            allertTitle: "Erro ao pesquisar repositórios",
            message: error.localizedError,
            actionTitle: "Tentar Novamente",
            style: .destructive,
            handler: nil
        )
        delegate?.errorToFetchRepositories(errorAllert: errorAlert)
    }
}
