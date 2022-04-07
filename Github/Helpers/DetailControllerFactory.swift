//
//  DetailControllerFactory.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import Foundation
import UIKit

class DetailControllerFactory {
	/**
	 ```
	 // Exemplo de Uso
	 class RepositoriesListViewController {
	     let repos: [GithubRespository] = []

	     // ...Metodos das Views e TableView

	     // Transicao para Detail após selecionar uma linha da tableView
	     func goToDetailRepository(_ indexPath: IndexPath) {
			let selectedRepo = repos.items[indexPath.row]
	         let newController = DetailControllerFactory.makeDetailController(from: selectedRepo)
	         self.navigationController?.pushViewController(
	             newController,
	             animated: true
	         )
	     }
	 }
	 ```
	 */
	static func makeDetailController(from repository: GithubRepository) -> DetailsViewController {
		DetailsViewController(
			.init(
				headerModel: .init(
					photo: repository.owner.avatarURL,
					description: repository.itemDescription ?? "No Description"
				),
				infoCellModels: [
					.init(
						icon: UIImage(systemName: "person.circle")!,
						title: "Autor",
						description: repository.fullName,
						tapHandle: nil
					),
					.init(
						icon: UIImage(systemName: "eye")!,
						title: "Contagem de Observadores",
						description: "\(repository.watchers)",
						tapHandle: nil
					),
					.init(
						icon: UIImage(systemName: "alarm.fill")!,
						title: "Data de Criação",
						description: repository.createdAt,
						tapHandle: nil
					),
					.init(
						icon: UIImage(systemName: "network")!,
						title: "Licença",
						description: repository.license?.name ?? "None",
						tapHandle: nil
					)
				],
				title: repository.name,
				link: repository.htmlURL
			)
		)
	}

	static func makeDetailController(
		from profile: GithubUser,
		phone: String,
		linkedin: String
	) -> DetailsViewController {
		DetailsViewController(
			.init(
				headerModel: .init(
					photo: profile.avatarURL,
					description: profile.bio ?? "No bio"
				),
				infoCellModels: [
					.init(
						icon: UIImage(systemName: "phone")!,
						title: "Telefone",
						description: phone,
						tapHandle: {
                            DeepLinkHandler.openURL(from: phone, type: .telephone)
						}
					),
					.init(
						icon: UIImage(systemName: "mail")!,
						title: "Email",
						description: profile.email ?? "No email",
						tapHandle: {
                            if profile.email != nil {
                                SendMailController().sendEmail(recipient: profile.email!)
                            }
						}
					),
					.init(
						icon: UIImage(systemName: "network")!,
						title: "LinkedIn",
						description: linkedin,
						tapHandle: {
                            DeepLinkHandler.openURL(from: linkedin, type: .linkedin)
						}
					),
					.init(
						icon: UIImage(systemName: "network")!,
						title: "Twitter",
						description: profile.twitterUsername ?? "No twitter",
						tapHandle: {
                            if profile.twitterUsername != nil {
                                DeepLinkHandler.openURL(from: profile.twitterUsername!, type: .twitter)
                            }
						}
					)
				],
				title: profile.name ?? "No name",
				link: nil
			)
		)
	}

    static func makeDetailController(from repository: FavoriteRepository) -> DetailsViewController {
        let repoController = DetailsViewController(
            .init(
                headerModel: .init(
                    photo: repository.linkAvatar,
                    description: repository.repositoryDescription
                ),
                infoCellModels: [
                    .init(
                        icon: UIImage(systemName: "person.circle")!,
                        title: "Autor",
                        description: repository.ownerName,
                        tapHandle: nil
                    ),
                    .init(
                        icon: UIImage(systemName: "eye")!,
                        title: "Contagem de Observadores",
                        description: "\(repository.watchersCount)",
                        tapHandle: nil
                    ),
                    .init(
                        icon: UIImage(systemName: "alarm.fill")!,
                        title: "Data de Criação",
                        description: DateFormatter().string(from: repository.createdAt),
                        tapHandle: nil
                    ),
                    .init(
                        icon: UIImage(systemName: "network")!,
                        title: "Licença",
                        description: repository.licenseTypeName,
                        tapHandle: nil
                    )
                ],
                title: repository.name,
                link: repository.repositoryUrl
            )
        )

        return repoController
    }

}
