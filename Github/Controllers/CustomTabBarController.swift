//
//  CustomTabBarController.swift
//  Github
//
//  Created by Alley Pereira on 31/03/22.
//

import UIKit

class CustomTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		configTabbar()
		tabBar.backgroundColor = .gray.withAlphaComponent(0.1)
		self.selectedIndex = 3
	}

	private func configTabbar() {

		let homeVC = HomeViewController(titleNav: "List")
		let favoritesVC = FavoritesViewController(titleNav: "Favoritos")
		let teamDevVC = TeamDevViewController(titleNav: "Time de Desenvolvedores")

		self.viewControllers = [
			embledNav(viewController: homeVC, title: "Home", image: "house.fill"),
			embledNav(viewController: favoritesVC, title: "Favoritos", image: "star.fill"),
			embledNav(viewController: teamDevVC, title: "Time", image: "person.2.fill")
		]
	}

	private func embledNav(
		viewController: UIViewController,
		title: String,
		image: String
	) -> UIViewController {
		let nav = UINavigationController(rootViewController: viewController)
		nav.tabBarItem.title = title
		nav.tabBarItem.image = UIImage(systemName: image)
		return nav
	}

}
