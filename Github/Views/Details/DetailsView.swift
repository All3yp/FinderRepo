//
//  DetailsView.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import UIKit

class DetailsView: UIControl {

	// MARK: Views

	let header: DetailsHeaderView = DetailsHeaderView()
	let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
	let footer: DetailsFooterView = DetailsFooterView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViewCode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(_ model: DetailViewModel) {
		header.configure(model.headerModel)
		footer.configure(model.link)
		tableView.reloadData()
	}

}

extension DetailsView: ViewCode {

	func buildHierarchy() {
		self.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: topAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}

	func configureViews() {
		tableView.separatorStyle = .none
		tableView.bounces = false
	}

}
