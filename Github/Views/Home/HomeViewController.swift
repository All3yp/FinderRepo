//
//  ViewController.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Lazy variables
    lazy var repositories = GithubRepositories(totalCount: 0,
                                               incompleteResults: false,
                                               items: []) {
        didSet {
            DispatchQueue.main.async {
                // TODO: Reload Data on tableView
                // TODO: Verify within CoreData, favorites. Use internal ID to store id: Int64
                print(self.repositories)
            }
        }
    }

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
        getInitialRepositories()
	}

    private func getInitialRepositories() {
        GithubApi.shared.getRepositories { response in
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                // TODO: Load Custom Error View!
                print(error)
            }
        }
    }

    private func getRepositoriesfrom(language: String, orderingBy: String) {
        // ascd, desc
    }
}
