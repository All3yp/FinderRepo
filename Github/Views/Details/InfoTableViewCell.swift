//
//  InfoTableViewCell.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

	private var iconImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.tintColor = .label
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		label.textColor = .label
		label.lineBreakMode = .byTruncatingHead
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, descriptionLabel])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 5
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	init() {
		super.init(style: .default, reuseIdentifier: nil)
		setupViewCode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(_ model: InfoCellModel) {
		iconImageView.image = model.icon
		titleLabel.text = model.title+":"
		descriptionLabel.text = model.description
	}

}

extension InfoTableViewCell: ViewCode {
	func buildHierarchy() {
		self.contentView.addSubview(stackView)
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
			stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

			iconImageView.heightAnchor.constraint(equalToConstant: 25),
			iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
		])
	}

	func configureViews() {
		self.backgroundColor = .clear
		self.selectionStyle = .none
	}
}
