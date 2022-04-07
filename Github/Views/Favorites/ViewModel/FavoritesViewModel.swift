//
//  FavoritesViewModel.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 07/04/22.
//

import Foundation
import UIKit

class FavoritesViewModel {

    let title = "Repositórios Favoritados"
    let backgroundColor = UIColor.white

    var favoriteRepositories: [FavoriteRepository]?
    weak var delegate: FavoritesViewDelegate?

    func getFavoriteRepository(from index: Int) -> FavoriteRepository? {
        favoriteRepositories?[index]
    }

    func fetchFavoriteRepositories() {
        favoriteRepositories = ManagedObjectContext.shared.listAll()
        didUpdateFavoriteRepositories()
    }

    func updateFavoriteRepository(_ repository: FavoriteRepository) {
        var repo: FavoriteRepository?
        ManagedObjectContext.shared.select(id: repository.id, onCompletionHandler: { result in
            repo = result
        })

        ManagedObjectContext.shared.update(id: repo!.id, isFavorite: !repo!.isFavorite) { result in
            print(result)
        }
        favoriteRepositories = ManagedObjectContext.shared.listAll()
        didUpdateFavoriteRepositoryWithSuccess(repository)
    }

    func didUpdateFavoriteRepositories() {
        delegate?.didUpdateFavoriteRepositories()
    }

    func didUpdateFavoriteRepositoryWithSuccess(_ repository: FavoriteRepository) {
        let successAllert = AppTheme.buildActionAllertDefault(
            allertTitle: "Poxa! 😔",
            message: "Repositório \(repository.name) removido com sucesso",
            actionTitle: "OK",
            style: .default,
            handler: nil
        )
        delegate?.didUpdateFavoriteRepositoryWithSuccess(successAlert: successAllert)
    }
}
