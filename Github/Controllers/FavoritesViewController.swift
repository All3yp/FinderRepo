//
//  FavoritesViewController.swift
//  Github
//
//  Created by Alley Pereira on 31/03/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: Lazy property variables
    lazy var repositories = [FavoriteRepository]() {
        didSet {
            DispatchQueue.main.async {
                self.updateFavoritesView()
            }
        }
    }

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomTableViewCell.self,
                       forCellReuseIdentifier: CustomTableViewCell.identifier)
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
        configureUI()

        view.backgroundColor = .systemBackground
        getFavoriteRepositories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
        getFavoriteRepositories()
    }

    private func updateFavoritesView() {
        tableView.reloadData()
    }

    private func configureUI() {
        title = "Repositórios"
        view.backgroundColor = .white
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configureNavigationController() {
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    private func getFavoriteRepositories() {
        repositories = ManagedObjectContext.shared.listAll()
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal,
                                          title: "Favoritar") { [weak self] (_, _, completion) in
            if let respository = self?.repositories[indexPath.row] {
                self?.handleMoveToFavorite(repository: respository)
                completion(true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self?.getFavoriteRepositories()
            }
        }
        favorite.backgroundColor = .lightGray
        favorite.image = UIImage(systemName: "star.fill")
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }

    private func handleMoveToFavorite(repository: FavoriteRepository) {
        var repo: FavoriteRepository?
        ManagedObjectContext.shared.select(id: repository.id, onCompletionHandler: { result in
            repo = result
        })

        ManagedObjectContext.shared.update(id: repo!.id, isFavorite: !repo!.isFavorite) { result in
            print(result)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                       for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let respository = repositories[indexPath.row]
        cell.setup(name: respository.name,
                   description: respository.repositoryDescription,
                   image: respository.linkAvatar,
                   date: nil,
                   isFavorite: true)
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedRepo = repositories[indexPath.row]
//        let repoDetailController = DetailControllerFactory.makeDetailController(from: selectedRepo)
//        self.navigationController?.pushViewController(repoDetailController, animated: true)
//    }
}



