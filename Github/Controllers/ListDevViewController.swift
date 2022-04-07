//
//  ListDevViewController.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
//

import UIKit

class ListDevViewController: UIViewController {

	lazy var tableview: UITableView = {
		let tableview = UITableView()
		tableview.translatesAutoresizingMaskIntoConstraints = false
		tableview.register(DevTableViewCell.self, forCellReuseIdentifier: DevTableViewCell.identifier)
		return tableview
	}()

	lazy var users = [(profile: GithubUser, phone: String, linkedin: String)]() {
		didSet {
			DispatchQueue.main.async {
				self.tableview.reloadData()
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

		view.backgroundColor = .white
		view.addSubview(tableview)
		delegates()
		getUsers()
		configConstraints()
	}

	private func getUsers() { // renatofsjr

		let users = [
			("All3yP", "+55(85)999998888", "https://www.linkedin.com/in/alley-pereira/"),
			("r-fsantos", "+55(85)977778888", "https://www.linkedin.com/in/renatofsjr/"),
			("alisonglima", "+55(85)988880000", "https://www.linkedin.com/in/alisonglima/"),
			("acsPrudencio", "+55(85)988997788", "https://www.linkedin.com/in/acsprudencio/")
		]

		users.forEach { user in
			GithubApi.shared.getProfile(named: user.0) { result in
				switch result {
				case .success(let profile):
					self.users.append(
						(profile: profile, phone: user.1, linkedin: user.2)
					)
				case .failure(let error):
					print(error)
				}
			}
		}

	}

	private func configConstraints() {
		NSLayoutConstraint.activate([
			self.tableview.topAnchor.constraint(equalTo: view.topAnchor),
			self.tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			self.tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			self.tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	private func delegates() {
		tableview.delegate = self
		tableview.dataSource = self
	}

}

extension ListDevViewController: UITableViewDelegate {

}

extension ListDevViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: DevTableViewCell.identifier,
			for: indexPath
		) as? DevTableViewCell else {
			return UITableViewCell()
		}

		let user = users[indexPath.row]

        cell.setup(name: user.profile.login ?? ListDevViewControllerConstants.noLogin,
                   photo: user.profile.avatarURL,
                   job: user.profile.bio)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let user = users[indexPath.row]
		let detailProfile = DetailControllerFactory.makeDetailController(
			from: user.profile,
			phone: user.phone,
			linkedin: user.linkedin
		)
		self.navigationController?.pushViewController(detailProfile, animated: true)
	}

}
