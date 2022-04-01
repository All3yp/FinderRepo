//
//  ViewController.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Lazy property variables
    lazy var repositories = GithubRepositories(totalCount: 0,
                                               incompleteResults: false,
                                               items: []) {
        didSet {
            DispatchQueue.main.async {
                self.updateHomeView()
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

    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = true
        search.searchBar.translatesAutoresizingMaskIntoConstraints = false
        search.searchBar.placeholder = "Vamos aprender uma linguagem hoje?"
        return search
    }()

    // MARK: Life Cycle
    /// Doubts:
    ///  configureNavigationController() should be called here?
    ///  should we add default response when one get blocked by Github API > XXXX requests per hour ?
    ///  should we identifyingInitialRepositoriesThatAreFavorite() at this point?

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
        getInitialRepositories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
    }

    private func updateHomeView() {
        searchController.isActive = false
        tableView.reloadData()
    }

    // MARK: UI Config - TODO: Create metrics file
    private func configureUI() {
        title = "Repositórios"
        view.backgroundColor = .white
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
        ])
    }

    // MARK: NavigationController Config
    /// TODO: Discuss navigationController?.navigationBar.prefersLargeTitles usage within the Team
    /// SHOULD we configure some appearence?
    private func configureNavigationController() {
        navigationItem.searchController = searchController

        let filterBarButton = UIBarButtonItem(image: UIImage.init(systemName: "slider.horizontal.3"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(displayOptions))

        navigationItem.rightBarButtonItem = filterBarButton
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    // MARK: Display ascd and desc Options? Anything else?
    @objc private func displayOptions() {

    }

    // MARK: Businees Rule method
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

    // MARK: Businees Rule method
    private func getRepositoriesfrom(language: String, orderingBy: String) {
        GithubApi.shared.getRepositoriesfrom(language: language, orderingBy: "desc") { response in
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal,
                                          title: "Favoritar") { [weak self] (_, _, completion) in
            if let respository = self?.repositories.items[indexPath.row] {
                self?.handleMoveToFavorite(repository: respository)
                completion(true)
            }
        }
        favorite.backgroundColor = .lightGray
        favorite.image = UIImage(systemName: "star.fill")
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }

    private func handleMoveToFavorite(repository: GithubRepository) {
        print("handleMoveToFavorite: \(repository)")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                       for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let respository = repositories.items[indexPath.row]
        cell.setup(name: respository.name,
                   description: respository.itemDescription,
                   image: respository.owner.avatarURL,
                   date: nil,
                   isFavorite: indexPath.row.isMultiple(of: 2) ? true : false)
        return cell
    }
}

extension HomeViewController: UISearchControllerDelegate {

}

extension HomeViewController: UISearchBarDelegate {

}

extension HomeViewController: UISearchResultsUpdating {
    // MARK: Pre-fetch repositories actions:
    /// pego o estado do botao (ascd, desc) ->
    /// enum Ordering { case ascending = "ascd" case descending = "desc") [particularidade da api]
    /// struct SearchPattern { let language: String, let ordering: Ordering }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setTitleCancelButton(searchBar)
        guard let rawTypedText = searchBar.text else { return }
        let typedText = rawTypedText.lowercased()
        getRepositoriesfrom(language: typedText, orderingBy: "")
    }

    func updateSearchResults(for searchController: UISearchController) {

    }

    private func setTitleCancelButton(_ searchBar: UISearchBar) {
        let cancelButton = searchBar.value(forKey: "cancelButton") as! UIButton
        cancelButton.setTitle("Cancelar", for: .normal)
    }
}
