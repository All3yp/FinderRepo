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
							// Chamar app do telefone passando o número
						}
					),
					.init(
						icon: UIImage(systemName: "mail")!,
						title: "Email",
						description: profile.email ?? "No email",
						tapHandle: {
							// Chamar app de email passando o email
						}
					),
					.init(
						icon: UIImage(systemName: "network")!,
						title: "LinkedIn",
						description: linkedin,
						tapHandle: {
							// Chamar browser ou app do linkedin passando o username
						}
					),
					.init(
						icon: UIImage(systemName: "network")!,
						title: "Twitter",
						description: profile.twitterUsername ?? "No twitter",
						tapHandle: {
							// Chamar browser ou app do twitter passando o twitter
						}
					)
				],
				title: profile.name ?? "No name",
				link: nil
			)
		)
	}
}
