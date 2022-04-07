//
//  FavoritesViewDelegate.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 07/04/22.
//

import Foundation
import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func didUpdateFavoriteRepositories()
    func didUpdateFavoriteRepositoryWithSuccess(successAlert: UIAlertController)
}
