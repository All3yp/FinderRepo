//
//  DetailsHeaderView.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import Foundation
import UIKit

class DetailsHeaderView: UIView {
	private let photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 20
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
		label.text = "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects"
		label.textColor = .label
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	init() {
		super.init(frame: .zero)
		setupViewCode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(_ model: DetailsHeaderModel) {
		descriptionLabel.text = model.description
		if let photoURL = model.photo,
		   let url = URL(string: photoURL) {
			photoImageView.kf.setImage(with: url)
		}
	}
}

extension DetailsHeaderView: ViewCode {
	func buildHierarchy() {
		self.addSubview(photoImageView)
		self.addSubview(descriptionLabel)
	}

	func setupConstraints() {
		let constant: CGFloat = 20
		NSLayoutConstraint.activate([
			photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
			photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			photoImageView.heightAnchor.constraint(equalToConstant: 200),
			photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),

			descriptionLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: constant),
			descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
			descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant),
			descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant)
		])
	}
}
