//
//  EditableListViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 24.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

protocol EditableListViewModel: UITableViewDataSource {

	var listTitle: String { get }
	var nameOfItems: String { get }
	var didSelectItem: ((_ index: Int) -> Void)? { get }

	func numberOfItems() -> Int
	func item(at index: Int) -> String
	func updateItem(at index: Int, with text: String)
	func createNewItem(with text: String)
	func deleteItem(at index: Int)

}

class EditableListViewController: UITableViewController {

	var editableListViewModel: EditableListViewModel {
		didSet {
			tableView.dataSource = editableListViewModel
		}
	}

	// MARK: - Initialization

	init(editableListViewModel: EditableListViewModel) {
		self.editableListViewModel = editableListViewModel

		super.init(nibName: nil, bundle: nil)
		hidesBottomBarWhenPushed = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Properties

	private lazy var inputTextAlertController: InputTextAlertController = .init(presentingViewController: self)

	// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

		initialSetup()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		tableView.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		setupToolBar()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.setToolbarHidden(true, animated: true)
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing {
			showEditAlertForItem(at: indexPath)
		} else {
			editableListViewModel.didSelectItem?(indexPath.row)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {

		let renameAction = UIContextualAction(style: .normal, title: L10n.Action.Title.rename) { (_, _, handler) in
			self.showEditAlertForItem(at: indexPath)
			handler(true)
		}

		let deleteAction = UIContextualAction(style: .destructive, title: L10n.Action.Title.delete) { (_, _, handler) in
			self.showDeletionAlertForItem(at: indexPath)
			handler(true)
		}

		return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
	}

}

// MARK: - Private Methods

private extension EditableListViewController {

	func initialSetup() {
		title = editableListViewModel.listTitle
		navigationItem.rightBarButtonItem = editButtonItem

		tableView.dataSource = editableListViewModel
		tableView.tableFooterView = UIView()
	}

	func setupToolBar() {
		let items: [UIBarButtonItem] = [
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertToCreateNewItem)),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		]

		setToolbarItems(items, animated: true)

		navigationController?.setToolbarHidden(false, animated: false)
	}

	func showDeletionAlertForItem(at indexPath: IndexPath) {

		let title = L10n.Alert.Title.delete(editableListViewModel.nameOfItems)
		let message = L10n.Alert.Message.delete(editableListViewModel.item(at: indexPath.row))

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: L10n.Action.Title.cancel, style: .cancel))
		alert.addAction(UIAlertAction(title: L10n.Action.Title.delete, style: .destructive) { _ in
			self.editableListViewModel.deleteItem(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .none)
		})

        present(alert, animated: true)
	}

	func showEditAlertForItem(at indexPath: IndexPath) {

		let text = editableListViewModel.item(at: indexPath.row)

		let title = L10n.Alert.Title.edit(editableListViewModel.nameOfItems)

		inputTextAlertController.showInputTextAlert(
			withTitle: title,
			actionTitle: L10n.Action.Title.save,
			textFieldPlaceholder: text) { [unowned self] (resultText) in

				self.editableListViewModel.updateItem(at: indexPath.row, with: resultText)
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}

	@objc
	func showAlertToCreateNewItem() {

		let title = L10n.Alert.Title.createNew(editableListViewModel.nameOfItems)

		inputTextAlertController.showInputTextAlert(
			withTitle: title,
			actionTitle: L10n.Action.Title.create) { [unowned self] (resultText) in

				let numberOfItems = self.editableListViewModel.numberOfItems()

				self.editableListViewModel.createNewItem(with: resultText)

				let newItemIndexPath = IndexPath(row: numberOfItems, section: 0)
				self.tableView.insertRows(at: [newItemIndexPath], with: .automatic)
				self.tableView.scrollToRow(at: newItemIndexPath, at: .none, animated: true)
		}
	}

}
