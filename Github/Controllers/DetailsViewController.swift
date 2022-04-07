//
//  DetailsViewController.swift
//  Github
//
//  Created by Alley Pereira on 02/04/22.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {

	let model: DetailViewModel

	lazy var detailsView: DetailsView = DetailsView(frame: UIScreen.main.bounds)

	init(_ model: DetailViewModel) {
		self.model = model
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = model.title
		detailsView.configure(model)

		detailsView.tableView.delegate = self
		detailsView.tableView.dataSource = self
		detailsView.footer.delegate = self
	}

	override func loadView() {
		super.loadView()
		self.view = detailsView
	}
}

extension DetailsViewController: DetailsFooterViewDelegate {
	func didPressRepositoryButton(_ repository: URL) {
        goTo(url: repository.description)
	}
}

extension DetailsViewController: WebBrowser {
    func goTo(url: String) {
        if let url = URL(string: url) {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = false

            let safariViewController = SFSafariViewController(url: url, configuration: configuration)
            safariViewController.delegate = self
            safariViewController.dismissButtonStyle = .close
            present(safariViewController, animated: true)
        }
    }
}

extension DetailsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		model.infoCellModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let currentCellModel = model.infoCellModels[indexPath.row]
		let cell = InfoTableViewCell()
		cell.configure(currentCellModel)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let currentCellModel = model.infoCellModels[indexPath.row]
		currentCellModel.tapHandle?()
	}

}

extension DetailsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		detailsView.header
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		350
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		(model.link != nil) ? detailsView.footer : nil
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		100
	}

}
