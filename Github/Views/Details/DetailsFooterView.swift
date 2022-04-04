//
//  DetailsFooterView.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import UIKit

protocol DetailsFooterViewDelegate: AnyObject {
	func didPressRepositoryButton(_ repository: URL)
}

class DetailsFooterView: UIView {

	weak var delegate: DetailsFooterViewDelegate?

	private lazy var repositoryButton: UIButton = {
		let button = UIButton(type: .system)
		button.tintColor = .label
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
		button.titleLabel?.text = "Link do repositório"
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(repositoryButtonAction), for: .touchUpInside)
		return button
	}()

	@objc private func repositoryButtonAction() {
		if let buttonTitle = repositoryButton.titleLabel?.text,
		   let url = URL(string: buttonTitle) {
			delegate?.didPressRepositoryButton(url)
		}
	}

	init() {
		super.init(frame: .zero)
		setupViewCode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(_ link: String?) {
		if let link = link {
			let attributes: [NSAttributedString.Key: Any] = [
				.underlineColor: UIColor.label,
				.underlineStyle: NSUnderlineStyle.single.rawValue,
				.font: UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
			]
			let attLink = NSAttributedString(string: link, attributes: attributes)
			repositoryButton.setAttributedTitle(attLink, for: .normal)
		}
	}

}

extension DetailsFooterView: ViewCode {
	func buildHierarchy() {
		self.addSubview(repositoryButton)
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			repositoryButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
			repositoryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
			repositoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			repositoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
		])
	}

	func configureViews() {
		repositoryButton.titleLabel?.numberOfLines = 0
	}
}
