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
                // TODO: Verify within CoreData, favorites. Use internal ID to store id: Int64
                self.tableView.reloadData()
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
        return search
    }()

    // TODO: Study App Views Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

        configureUI()
//        configureNavigationController()
        // TODO: Add default response when one get blocked by Github API > XXXX requests per hour
        getInitialRepositories()
        // identifyingInitialRepositoriesThatAreFavorite()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationController()
    }

    private func configureUI() {
        title = "Repositórios"

        view.backgroundColor = .white

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            // TODO: Create metrics file
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
        ])
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

    private func configureNavigationController() {
        // TODO: Discuss navigationController?.navigationBar.prefersLargeTitles usage within the Team
        // navigationController?.navigationBar.prefersLargeTitles = true

        // TODO: Configure Appearance

        navigationItem.searchController = searchController

        let filterBarButton = UIBarButtonItem(image: UIImage.init(systemName: "slider.horizontal.3"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(displayOptions))

        navigationItem.rightBarButtonItem = filterBarButton
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    @objc private func displayOptions() {
        /// Display ascd and desc
    }
}


extension HomeViewController: UITableViewDelegate {

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
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // pego o conteúdo -> OK
        // pego o estado do botao (ascd, desc) ->
        // sensibilizo a variavel que armazena repositorios (struct: language, ordering) ->
        // getRepositoriesfrom(searchPattern: SearchPattern)
        // enum Ordering { case ascending = "ascd" case descending = "desc") [particularidade da api]
        // struct SearchPattern { let language: String, let ordering: Ordering }
        guard let typedText = searchBar.text else { return }
        print(typedText)
    }

    func updateSearchResults(for searchController: UISearchController) {
        // No need to be implemented
    }
}
