//
//  ViewController.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(DevTableViewCell.self, forCellReuseIdentifier: DevTableViewCell.identifier)
        return tableview
    }()
    
    lazy var users = [User]() {
            didSet {
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    print(self.users)
                }
            }
        }

    // MARK: Lazy variables
    lazy var repositories = GithubRepositories(totalCount: 0,
                                               incompleteResults: false,
                                               items: []) {
        didSet {
            DispatchQueue.main.async {
                // TODO: Reload Data on tableView
                // TODO: Verify within CoreData, favorites. Use internal ID to store id: Int64
               // print(self.repositories)
            }
        }
    }

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white
        view.addSubview(tableview)
        delegates()
        getUsers()
        getInitialRepositories()
        configConstraints()

        
	}
    
    private func getUsers() {
            
        DevProfileApi.shared.getUsers { result in
                
                switch result {
                case .success(let res):
                    self.users = res
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    
    private func configConstraints(){
        NSLayoutConstraint.activate([
            self.tableview.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func delegates(){
        tableview.delegate = self
        tableview.dataSource = self
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

extension HomeViewController: UITableViewDelegate {

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DevTableViewCell.identifier, for: indexPath) as? DevTableViewCell else {
                return UITableViewCell()
            }
            

        let user = users[indexPath.row]

        cell.setup(name: user.name, photo: user.photo, job: user.job)
        
        return cell
        

        }
    
}
