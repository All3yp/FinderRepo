//
//  FavoritesViewController.swift
//  Github
//
//  Created by Alley Pereira on 31/03/22.
//

import UIKit

class FavoritesViewController: UIViewController {

	init(titleNav: String) {
		super.init(nibName: nil, bundle: nil)
		title = titleNav
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
	}

}
