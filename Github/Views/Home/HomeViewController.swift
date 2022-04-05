// swiftlint:disable force_cast
//  ViewController.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    private let pickerOptions = ["Ascendente", "Descendente"]
    public var orderingBy = "asc"

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

    lazy var favoriteRepositories: GithubRepositories =  GithubRepositories(totalCount: 0,
                                                                            incompleteResults: false,
                                                                            items: [])

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

    lazy var pickerView: UIPickerView = {
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        var picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect(x: 0.0, y: height - 300, width: width, height: 300)
        return picker
    }()

    lazy var toolBar: UIToolbar = {
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        var toolbar = UIToolbar()
        toolbar.frame = CGRect.init(x: 0.0, y: height - 300, width: width, height: 50)
        toolbar.barStyle = .black
        toolbar.items = [.init(title: "Selecionar", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        return toolbar
    }()

    // MARK: Life Cycle
    /// Doubts:
    ///  configureNavigationController() should be called here?
    ///  should we add default response when one get blocked by Github API > XXXX requests per hour ?
    ///  should we identifyingInitialRepositoriesThatAreFavorite() at this point?
    ///
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
        setFavoritesStar()

        pickerView.selectRow(0, inComponent: 0, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
        updateHomeView()
    }

    private func updateHomeView() {
        setFavoritesStar()
        searchController.isActive = false
        tableView.reloadData()
    }

    private func setFavoritesStar() {
        let favRepositories = ManagedObjectContext.shared.listAllIds()
        favoriteRepositories.items = repositories.items.map { repository in
            var newRepository = repository
            if favRepositories.contains(repository.id) {
                newRepository.isFavorite = true
            }

            return newRepository
        }
    }

    // MARK: UI Config, Create metrics file
    private func configureUI() {
        title = "Repositórios"
        view.backgroundColor = .white
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0)
        ])
    }

    // MARK: NavigationController Config
    // Discuss navigationController?.navigationBar.prefersLargeTitles usage within the Team
    // SHOULD we configure some appearence?
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
        setupPicker()
    }

    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        pickerView.removeFromSuperview()
        orderingBy = pickerView.selectedRow(inComponent: 0) == 1 ? "desc" : "asc"
        print(orderingBy)
    }

    // MARK: Businees Rule method
    private func getInitialRepositories() {
        GithubApi.shared.getRepositories { response in
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                // MARK: Load Custom Error View!
                print(error)
            }
        }
    }

    // MARK: Businees Rule method
    private func getRepositoriesfrom(language: String, orderingBy: String) {
        GithubApi.shared.getRepositoriesfrom(language: language, orderingBy: orderingBy) { response in
            switch response {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupPicker() {
        self.view.addSubview(pickerView)
        self.view.addSubview(toolBar)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal,
                                          title: "Favoritar") { [weak self] (_, _, completion) in
            if let respository = self?.repositories.items[indexPath.row] {
                self?.handleMoveToFavorite(repository: respository)
                completion(true)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                self?.updateHomeView()
            }
        }
        favorite.backgroundColor = .lightGray
        favorite.image = UIImage(systemName: "star.fill")
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }

    private func handleMoveToFavorite(repository: GithubRepository) {
        var repo: FavoriteRepository?
        ManagedObjectContext.shared.select(id: repository.id, onCompletionHandler: { result in
            repo = result
        })

        if repo != nil {
            ManagedObjectContext.shared.update(id: repo!.id, isFavorite: !repo!.isFavorite) { result in
                print(result)
            }
        } else {
            ManagedObjectContext.shared.create(repository: repository) { result in
                print(result)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteRepositories.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                       for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let repository = favoriteRepositories.items[indexPath.row]
        cell.setup(name: repository.name,
                   description: repository.itemDescription,
                   image: repository.owner.avatarURL,
                   date: nil,
                   isFavorite: repository.isFavorite ?? false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = favoriteRepositories.items[indexPath.row]
        let repoDetailController = DetailControllerFactory.makeDetailController(from: selectedRepo)
        self.navigationController?.pushViewController(repoDetailController, animated: true)
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

extension HomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
}

extension HomeViewController: UIPickerViewDelegate {

}
