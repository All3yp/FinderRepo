//
//  HomeViewModelDelegate.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 06/04/22.
//

import Foundation
import UIKit

protocol HomeViewDelegate: AnyObject {
    func didUpdateRepositories()
    func errorToFetchRepositories(errorAllert: UIAlertController)
}
