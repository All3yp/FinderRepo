//
//  HomeViewModel.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 05/04/22.
//

import Foundation

// MVVM + Pop
protocol HomeViewDelegate: AnyObject {
    func didUpdateRepositories()
}

class HomeViewModel {
    
    lazy var repositories = GithubRepositories(totalCount: 0,
                                               incompleteResults: false,
                                               items: []) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didUpdateRepositories()
            }
        }
    }
    
    weak var delegate: HomeViewDelegate?
    
    func fetchRepositories() {
        GithubApi.shared.getRepositories { response in
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                // MARK: Load Custom Error View!
                print(error)
            }
        }
    }
    
    func fetchRepositories(from language: String, orderingBy: String) {
        GithubApi.shared.getRepositoriesfrom(language: language, orderingBy: orderingBy) { response in
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print(error)
            }
        }
    }
}
