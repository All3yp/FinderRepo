//  ViewController.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    enum PickerConstants: String {
        case ascending = "asc"
        case descending = "desc"
    }

    private let pickerOptions = ["Ascendente", "Descendente"]
    private var orderingBy = "asc"
    private let viewModel: HomeViewModel = HomeViewModel()

    lazy var favoriteRepositories = GithubRepositories(
        totalCount: 0,
        incompleteResults: false,
        items: []
    )

    lazy var tableView: UITableView = {
        let table = AppTheme.buildTableView(frame: .zero,
                                            style: .plain,
                                            delegateReference: self)
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
        toolbar.items = [.init(title: "Selecionar",
                               style: .done,
                               target: self,
                               action: #selector(onDoneButtonTapped))]
        return toolbar
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
        tableView = AppTheme.buildTableView(frame: .zero, style: .plain, delegateReference: self)
        setupViewCode()
        setupView()
        configureNavigationController()
        viewModel.fetchRepositories(from: nil, orderingBy: orderingBy)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRepositories(from: nil, orderingBy: orderingBy)
//        setFavoritesStar()
        updateHomeView()
    }

    private func setupView() {
        view.backgroundColor = HomeColors.backgroundColor
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }

    private func updateHomeView() {
        setFavoritesStar()
        searchController.isActive = false
        tableView.reloadData()
    }

    // MARK: Move to ViewModel
    private func setFavoritesStar() {
        let favRepositories = ManagedObjectContext.shared.listAllIds()

        if let repositories = viewModel.repositories {
            favoriteRepositories.items = repositories.items.map { repository in
                var newRepository = repository
                if favRepositories.contains(repository.id) {
                    newRepository.isFavorite = true
                }
                return newRepository
            }
        }
    }

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
        orderingBy = pickerView.selectedRow(
            inComponent: 0
        ) == 1 ? PickerConstants.descending.rawValue : PickerConstants.ascending.rawValue
    }

    private func setupPicker() {
        view.addSubview(pickerView)
        view.addSubview(toolBar)
    }
}

extension HomeViewController: ViewCode {

    func buildHierarchy() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0)
        ])
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(
            style: .normal,
            title: "Favoritar"
        ) { [weak self] (_, _, completion) in

            // MARK: - BEDONE = Create method for get repository item from index
            if let repository = self?.favoriteRepositories.items[indexPath.row] {
                var title = "Eba!"
                var favoriteMessage = "Favoritado"
                self?.handleMoveToFavorite(repository: repository)
                if repository.isFavorite != nil {
                    if repository.isFavorite == true {
                        title = "Poxa! :("
                        favoriteMessage = "Desfavoritado"
                    }
                }
                let allertMessage = "Repositório \(repository.name) \(favoriteMessage)!"
                let allertFavoriteSuccess = AppTheme.buildActionAllertDefault(
                    allertTitle: title,
                    message: allertMessage,
                    actionTitle: "OK",
                    style: .default,
                    handler: nil
                )
                self?.present(allertFavoriteSuccess, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self?.updateHomeView()
                }
                completion(true)
            }
        }
        favorite.backgroundColor = .purple
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

                if case .failure(let error) = result {
                    // MARK: to be done Create Alert - suggestion: Create View extension to invoke the alert
                    print(error.localizedDescription)
                }
            }
        } else {
            ManagedObjectContext.shared.create(repository: repository) { result in
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
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
        if let repositories = viewModel.repositories {
            let selectedRepo = repositories.items[indexPath.row]
            let repoDetailController = DetailControllerFactory.makeDetailController(from: selectedRepo)
            navigationController?.pushViewController(repoDetailController, animated: true)
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func didUpdateRepositories() {
        updateHomeView()
    }

    func errorToFetchRepositories(errorAllert: UIAlertController) {
        searchController.isActive = false
        present(errorAllert, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchControllerDelegate {}

extension HomeViewController: UISearchBarDelegate {}

extension HomeViewController: UISearchResultsUpdating {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let rawTypedText = searchBar.text else { return }
        let typedText = rawTypedText.lowercased()
        viewModel.fetchRepositories(from: typedText, orderingBy: orderingBy)
    }

    func updateSearchResults(for searchController: UISearchController) {}
}
extension HomeViewController: UIPickerViewDelegate {}

extension HomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerOptions[row]
    }
}
