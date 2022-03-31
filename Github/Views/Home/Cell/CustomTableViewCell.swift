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
        let image = UIImageView()
//        image.layer.masksToBounds = false
//        image.layer.cornerRadius = frame.size.width / 2
//        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
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
        // TODO: Create metrics file
        stack.spacing = 10
        stack.contentMode = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    // TODO: Refactor this method.
    /// Parameters can placed inside of a Container like struct
    func setup(name: String,
               description: String?,
               image: String?,
               date: String?,
               isFavorite: Bool) {
        titleLabel.text = isFavorite ? "⭐️ \(name)" : name
        descriptionLabel.text = description ?? "Repositório sem descrição"

        if let image = image {
            let url = URL(string: image)
            let processor = RoundCornerImageProcessor(cornerRadius: 35)
            iconImageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])
        } else {
            iconImageView.image = UIImage(systemName: "airplane")
        }
    }

    private func configureUI() {
        addSubview(iconImageView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            // TODO: Adjust this guy, considering NavBar and SearchBar!
            // TODO: Create Metrics file
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
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
