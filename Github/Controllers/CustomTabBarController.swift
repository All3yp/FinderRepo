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
        tabBar.backgroundColor = TabBarColors.backgroundColor
        selectedIndex = TabBarConstants.selectedIndex
	}

	private func configTabbar() {

        let homeVC = HomeViewController(titleNav: HomeConstants.titleNav)
        let favoritesVC = FavoritesViewController(titleNav: FavoritesConstants.titleNav)
        let teamDevVC = ListDevViewController(titleNav: TeamDevelopersConstants.titleNav)

        let homeViewModel = HomeViewModel()
        homeVC.viewModel = homeViewModel

        self.viewControllers = [
            embledNav(viewController: homeVC,
                      title: HomeConstants.titleBar,
                      image: HomeConstants.iconBar),
            embledNav(viewController: favoritesVC,
                      title: FavoritesConstants.titleBar,
                      image: FavoritesConstants.iconBar),
            embledNav(viewController: teamDevVC,
                      title: TeamDevelopersConstants.titleBar,
                      image: TeamDevelopersConstants.iconBar)
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
