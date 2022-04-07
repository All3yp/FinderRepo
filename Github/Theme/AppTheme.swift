//
//  AppTheme.swift
//  Github
//
//  Created by Renato F. dos Santos Jr on 06/04/22.
//

import Foundation
import UIKit

class AppTheme {

    static func buildActionAllertDefault(
        allertTitle: String,
        message: String,
        actionTitle: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> UIAlertController {
        let allert = UIAlertController(title: allertTitle,
                                       message: message,
                                       preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle,
                                   style: style,
                                   handler: handler)
        allert.addAction(action)
        return allert
    }

    static func buildTableView(
        frame: CGRect,
        style: UITableView.Style,
        delegateReference: UIViewController,
        cellClass: AnyClass?,
        cellClassIdentifier: String
    ) -> UITableView {
        let table = UITableView(frame: frame, style: style)
        table.delegate = delegateReference.self as? UITableViewDelegate
        table.dataSource = delegateReference.self as? UITableViewDataSource
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(cellClass.self,
                       forCellReuseIdentifier: cellClassIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }

    static func buildSearchController(
        searchResultsController: UIViewController?,
        delegateReference: UIViewController,
        placeholder: String
    ) -> UISearchController {
        let search = UISearchController(searchResultsController: searchResultsController)
        search.delegate = delegateReference.self as? UISearchControllerDelegate
        search.searchBar.delegate = delegateReference.self as? UISearchBarDelegate
        search.searchResultsUpdater = delegateReference.self as? UISearchResultsUpdating
        search.obscuresBackgroundDuringPresentation = true
        search.searchBar.translatesAutoresizingMaskIntoConstraints = false
        search.searchBar.placeholder = placeholder
        return search
    }

}
