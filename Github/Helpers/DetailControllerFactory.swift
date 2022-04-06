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
		let repoController = DetailsViewController(
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

		return repoController
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

//	static func makeDetailController(from profile: User ou Owner) -> DetailsViewController {
//		let profileController = DetailsViewController(
//			.init(
//				headerModel: .init(
//					photo: "https://avatars.githubusercontent.com/u/29764688?",
//					description: "iOS developer."
//				),
//				infoCellModels: [
//					.init(
//						icon: UIImage(systemName: "phone")!,
//						title: "Telefone",
//						description: "(00)0000-0000",
//						tapHandle: {
//							// Chamar app do telefone passando o número
//						}
//					),
//					.init(
//						icon: UIImage(systemName: "mail")!,
//						title: "Email",
//						description: "fulano@fulano.com.br",
//						tapHandle: {
//							// Chamar app de email passando o email
//						}
//					),
//					.init(
//						icon: UIImage(systemName: "network")!,
//						title: "LinkedIn",
//						description: "url",
//						tapHandle: {
//							// Chamar browser ou app do linkedin passando o username
//						}
//					),
//					.init(
//						icon: UIImage(systemName: "network")!,
//						title: "Twitter",
//						description: "url (opcional)",
//						tapHandle: {
//							// Chamar browser ou app do twitter passando o twitter
//						}
//					)
//				],
//				title: "All3yP",
//				link: nil
//			)
//		)
//	}
}
