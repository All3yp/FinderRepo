//
//  DetailViewModel.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import Foundation
import UIKit

struct DetailViewModel {
	let headerModel: DetailsHeaderModel
	let infoCellModels: [InfoCellModel]
	let title: String
	let link: String?
}

struct InfoCellModel {
	let icon: UIImage
	let title: String
	let description: String
}

struct DetailsHeaderModel {
	let photo: String?
	let description: String
}
