// swiftlint:disable type_name force_cast line_length

import Foundation
import CoreData
import UIKit

typealias onCompletionHandler = (Result<String, Error>) -> Void

protocol ManagedListAllProtocol {
    func listAll() -> [FavoriteRepository]
}

protocol ManagedCreateProtocol {
    func create(repository: GithubRepository, onCompletionHandler: onCompletionHandler)
}

protocol ManagedUpdateProtocol {
    func update(id: Int, isFavorite: Bool, onCompletionHandler: onCompletionHandler)
}

protocol ManagedSelectProtocol {
    func select(id: Int, onCompletionHandler: (FavoriteRepository?) -> Void)
}

class ManagedObjectContext {
    private let entity = "FavoriteRepositoryEntity"

    static var shared: ManagedObjectContext {
        let instance = ManagedObjectContext()
        return instance
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

extension ManagedObjectContext: ManagedCreateProtocol {
    func create(repository: GithubRepository, onCompletionHandler: onCompletionHandler) {
        let context = getContext()

        let favoriteRepository = FavoriteRepositoryEntity(context: context)

        let dateFormatter = ISO8601DateFormatter()
        let createdAt = dateFormatter.date(from: repository.createdAt)!

        favoriteRepository.setValue(repository.id, forKey: "id")
        favoriteRepository.setValue(repository.name, forKey: "name")
        favoriteRepository.setValue(repository.itemDescription, forKey: "repositoryDescription")
        favoriteRepository.setValue(repository.owner.avatarURL, forKey: "linkAvatar")
        favoriteRepository.setValue(repository.htmlURL, forKey: "repositoryUrl")
        favoriteRepository.setValue(repository.owner.login, forKey: "ownerName")
        favoriteRepository.setValue(repository.watchers, forKey: "watchersCount")
        favoriteRepository.setValue(createdAt, forKey: "repositoryCreatedAt")
        favoriteRepository.setValue(repository.license?.name, forKey: "licenseTypeName")
        favoriteRepository.setValue(Date(), forKey: "createdAt")
        favoriteRepository.setValue(true, forKey: "isFavorite")

        do {
            try context.save()
            onCompletionHandler(.success("Saved"))
        } catch {
            onCompletionHandler(.failure(error))
        }
    }
}

extension ManagedObjectContext: ManagedUpdateProtocol {
    func update(id: Int, isFavorite: Bool, onCompletionHandler: onCompletionHandler) {
        let context = getContext()

        let predicate = NSPredicate(format: "id == %@", "\(id)")

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate

        do {

            let fecthResults = try context.fetch(fetchRequest) as! [NSManagedObject]

            if let entityUpdate = fecthResults.first {
                entityUpdate.setValue(isFavorite, forKey: "isFavorite")
            }

            try context.save()

            onCompletionHandler(.success("Update Success"))

        } catch {
            onCompletionHandler(.failure(error))
        }
    }
}

extension ManagedObjectContext: ManagedListAllProtocol {
    func listAll() -> [FavoriteRepository] {

        var listFavoriteRepositories: [FavoriteRepository] = []

        let fecthRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        do {
            guard let favoriteRepositories = try getContext().fetch(fecthRequest) as? [NSManagedObject] else {
                print("Error in request ")
                return listFavoriteRepositories

            }

            for favoriteRepository in favoriteRepositories {

                if let id = favoriteRepository.value(forKey: "id") as? Int,
                   let name = favoriteRepository.value(forKey: "name") as? String,
                   let repositoryDescription = favoriteRepository.value(forKey: "repositoryDescription") as? String,
                   let linkAvatar = favoriteRepository.value(forKey: "linkAvatar") as? String,
                   let repositoryUrl = favoriteRepository.value(forKey: "repositoryUrl") as? String,
                   let ownerName = favoriteRepository.value(forKey: "ownerName") as? String,
                   let watchersCount = favoriteRepository.value(forKey: "watchersCount") as? Int,
                   let repositoryCreatedAt = favoriteRepository.value(forKey: "repositoryCreatedAt") as? Date,
                   let licenseTypeName = favoriteRepository.value(forKey: "licenseTypeName") as? String,
                   let createdAt = favoriteRepository.value(forKey: "createdAt") as? Date,
                   let isFavorite = favoriteRepository.value(forKey: "isFavorite") as? Bool {

                    let favoriteRepository = FavoriteRepository(id: id, name: name, repositoryDescription: repositoryDescription, linkAvatar: linkAvatar, repositoryUrl: repositoryUrl, ownerName: ownerName, watchersCount: watchersCount, repositoryCreatedAt: repositoryCreatedAt, licenseTypeName: licenseTypeName, createdAt: createdAt, isFavorite: isFavorite)

                    if isFavorite {
                        listFavoriteRepositories.append(favoriteRepository)
                    }
                }
            }

        } catch let error as NSError {
            print("Error in request \(error.localizedDescription)")
        }
        return listFavoriteRepositories
    }

}

extension ManagedObjectContext {
    func listAllIds() -> [Int] {

        var listFavoriteRepositories: [Int] = []

        let fecthRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        do {
            guard let favoriteRepositories = try getContext().fetch(fecthRequest) as? [NSManagedObject] else {
                print("Error in request ")
                return []

            }

            for favoriteRepository in favoriteRepositories {

                if let id = favoriteRepository.value(forKey: "id") as? Int,
                   let isFavorite = favoriteRepository.value(forKey: "isFavorite") as? Bool {

                    if isFavorite {
                        listFavoriteRepositories.append(id)
                    }
                }
            }

        } catch let error as NSError {
            print("Error in request \(error.localizedDescription)")
        }
        return listFavoriteRepositories
    }

}

extension ManagedObjectContext: ManagedSelectProtocol {
    func select(id: Int, onCompletionHandler: (FavoriteRepository?) -> Void) {
        let context = getContext()

        let predicate = NSPredicate(format: "id == %@", "\(id)")

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate

        do {

            let fecthResults = try context.fetch(fetchRequest) as! [NSManagedObject]

            if let favoriteRepository = fecthResults.first {
                if let id = favoriteRepository.value(forKey: "id") as? Int,
                   let name = favoriteRepository.value(forKey: "name") as? String,
                   let repositoryDescription = favoriteRepository.value(forKey: "repositoryDescription") as? String,
                   let linkAvatar = favoriteRepository.value(forKey: "linkAvatar") as? String,
                   let repositoryUrl = favoriteRepository.value(forKey: "repositoryUrl") as? String,
                   let ownerName = favoriteRepository.value(forKey: "ownerName") as? String,
                   let watchersCount = favoriteRepository.value(forKey: "watchersCount") as? Int,
                   let repositoryCreatedAt = favoriteRepository.value(forKey: "repositoryCreatedAt") as? Date,
                   let licenseTypeName = favoriteRepository.value(forKey: "licenseTypeName") as? String,
                   let createdAt = favoriteRepository.value(forKey: "createdAt") as? Date,
                   let isFavorite = favoriteRepository.value(forKey: "isFavorite") as? Bool {

                    let favoriteRepository = FavoriteRepository(id: id, name: name, repositoryDescription: repositoryDescription, linkAvatar: linkAvatar, repositoryUrl: repositoryUrl, ownerName: ownerName, watchersCount: watchersCount, repositoryCreatedAt: repositoryCreatedAt, licenseTypeName: licenseTypeName, createdAt: createdAt, isFavorite: isFavorite)

                    onCompletionHandler(favoriteRepository)
                }

            }

        } catch let error as NSError {
            print("Fetch failed \(error.localizedDescription)")
        }
    }

}
