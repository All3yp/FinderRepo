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
					photo: "https://www.swift.org/apple-touch-icon-180x180.png",
					description: repository.itemDescription ?? "No Description"
				),
				infoCellModels: [
					.init(
						icon: UIImage(systemName: "person.circle")!,
						title: "Autor",
						description: repository.fullName
					),
					.init(
						icon: UIImage(systemName: "eye")!,
						title: "Contagem de Observadores",
						description: "\(repository.watchers)"
					),
					.init(
						icon: UIImage(systemName: "alarm.fill")!,
						title: "Data de Criação",
						description: repository.createdAt
					),
					.init(
						icon: UIImage(systemName: "network")!,
						title: "Licença",
						description: repository.license?.name ?? "None"
					)
				],
				title: repository.name,
				link: repository.htmlURL
			)
		)

		return repoController
	}

//	static func makeDetailController(from profile: GithubProfile) -> DetailsViewController {
//		let profileController = DetailsViewController(
//			.init(
//				headerModel: .init(
//					photo: "https://avatars.githubusercontent.com/u/29764688?v=4",
//					description: "Master student degree computer science UFPE, iOS developer with a UX/UI design background."
//				),
//				infoCellModels: [
//					.init(
//						icon: UIImage(systemName: "phone")!,
//						title: "Telefone",
//						description: "(00)0000-0000"
//					),
//					.init(
//						icon: UIImage(systemName: "mail")!,
//						title: "Email",
//						description: "fulano@fulano.com.br"
//					),
//					.init(
//						icon: UIImage(systemName: "network")!,
//						title: "LinkedIn",
//						description: "url"
//					),
//					.init(
//						icon: UIImage(systemName: "network")!,
//						title: "Twitter",
//						description: "url (opcional)"
//					)
//				],
//				title: "All3yP",
//				link: nil
//			)
//		)
//	}
}
