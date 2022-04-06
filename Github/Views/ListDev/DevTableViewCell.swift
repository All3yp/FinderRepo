//
//  TableViewCell.swift
//  Github
//
//  Created by Idwall Go Dev 014 on 31/03/22.
//

import UIKit
import Kingfisher

class DevTableViewCell: UITableViewCell {

	static let identifier = "DevTableViewCell"

	lazy var imageViewProfile: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.masksToBounds = false
		imageView.layer.cornerRadius = 40
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	lazy var contentStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .top
		stack.distribution = .fillProportionally
		accessoryType = AccessoryType.disclosureIndicator
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.spacing = -20
		return stack
	}()

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = UIFont.systemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 13)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	lazy var plusImage: UIImageView = {
		let plusImage = UIImageView()
		plusImage.translatesAutoresizingMaskIntoConstraints = false
		return plusImage
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		addSubview(imageViewProfile)

		NSLayoutConstraint.activate([
			imageViewProfile.widthAnchor.constraint(equalToConstant: 80),
			imageViewProfile.heightAnchor.constraint(equalToConstant: 80),
			imageViewProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			imageViewProfile.centerYAnchor.constraint(equalTo: centerYAnchor)
		])

		addSubview(contentStack)

		contentStack.addArrangedSubview(titleLabel)
		contentStack.addArrangedSubview(descriptionLabel)

		NSLayoutConstraint.activate([
			contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			contentStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5),
			contentStack.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 16),
			contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
			contentStack.heightAnchor.constraint(equalToConstant: 90)
		])
	}

	func setup(
		name: String,
		photo: String?,
		job: String?
	) {
		titleLabel.text = name
		descriptionLabel.text = job

		if let photo = photo {
			let url = URL(string: photo)
			//     let processor = RoundCornerImageProcessor(cornerRadius: 35)
			imageViewProfile.kf.setImage(with: url, placeholder: nil)
		} else {
			imageViewProfile.image = UIImage(systemName: "person")
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

}
