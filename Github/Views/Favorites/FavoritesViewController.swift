//
//  FavoritesViewController.swift
//  Github
//
//  Created by Alley Pereira on 31/03/22.
//

import UIKit

class FavoritesViewController: UIViewController {

    var viewModel: FavoritesViewModel = FavoritesViewModel()

    lazy var tableView: UITableView = {
        let table = AppTheme.buildTableView(
            frame: .zero,
            style: .plain,
            delegateReference: self,
            cellClass: CustomTableViewCell.self,
            cellClassIdentifier: CustomTableViewCell.self.identifier
        )
        return table
    }()

    init(titleNav: String) {
        super.init(nibName: nil, bundle: nil)
        title = titleNav
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupViewCode()
        setupView()
        getFavoriteRepositories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
        getFavoriteRepositories()
    }

    private func setupView() {
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }

    private func configureNavigationController() {
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    private func getFavoriteRepositories() {
        viewModel.fetchFavoriteRepositories()
    }

    private func favoritesViewUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.tableView.reloadData()
        }
    }
}

extension FavoritesViewController: ViewCode {

    func buildHierarchy() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension FavoritesViewController: FavoritesViewDelegate {
    func didUpdateFavoriteRepositories() {
        favoritesViewUpdate()
    }

    func didUpdateFavoriteRepositoryWithSuccess(successAlert: UIAlertController) {
        present(successAlert, animated: true, completion: nil)
        favoritesViewUpdate()
    }
}

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal,
                                          title: "Remover") { [weak self] (_, _, completion) in
            if let repository = self?.viewModel.getFavoriteRepository(from: indexPath.row) {
                self?.viewModel.updateFavoriteRepository(repository)
                completion(true)
            }
        }
        favorite.backgroundColor = .red
        favorite.image = UIImage(systemName: "star.fill")
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }
}

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoriteRepositories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                       for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        if let repository = viewModel.favoriteRepositories?[indexPath.row] {
        cell.setup(name: repository.name,
                   description: repository.repositoryDescription,
                   image: repository.linkAvatar,
                   date: nil,
                   isFavorite: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRepo = viewModel.favoriteRepositories?[indexPath.row] {
            let repoDetailController = DetailControllerFactory.makeDetailController(from: selectedRepo)
            navigationController?.pushViewController(repoDetailController, animated: true)
        }
    }
}
