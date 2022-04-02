//
//  ViewCode.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import Foundation

protocol ViewCode {
	func buildHierarchy()
	func setupConstraints()
	func configureViews()
}

extension ViewCode {
	func setupViewCode() {
		buildHierarchy()
		setupConstraints()
		configureViews()
	}

	func configureViews() { }
}
