//
//  CustomTableViewCell.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 30/03/22.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"

    lazy var iconImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        accessoryType = AccessoryType.disclosureIndicator
        stack.axis = .vertical
        stack.spacing = 16
        stack.contentMode = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    func setup(name: String,
               description: String?,
               image: String?,
               date: String?,
               isFavorite: Bool) {
        titleLabel.text = isFavorite ? "⭐️ \(name)" : name
        descriptionLabel.text = description ?? "Repositório sem descrição"

        if let image = image {
            let url = URL(string: image)
            iconImageView.kf.setImage(with: url?.downloadURL, placeholder: nil, options: nil)
        } else {
            iconImageView.image = UIImage(systemName: "airplane")
        }
    }

    private func configureUI() {
        addSubview(iconImageView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

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
