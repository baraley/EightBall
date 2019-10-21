//
//  ContentListViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 24.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class ContentListViewController: UITableViewController {

	enum Change {
		case update(Int)
		case insert(Int)
		case delete(Int)
		case move(Int, Int)
	}

	private let contentListViewModel: ContentListViewModel

	// MARK: - Initialization

	init(contentListViewModel: ContentListViewModel) {
		self.contentListViewModel = contentListViewModel

		super.init(nibName: nil, bundle: nil)

		if contentListViewModel.isCreationAvailable {
			hidesBottomBarWhenPushed = true
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Properties

	private lazy var inputTextAlertController = InputTextAlertController(presentingViewController: self)

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		initialSetup()
		setupViewModel()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		tableView.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if contentListViewModel.isCreationAvailable {
			navigationController?.setToolbarHidden(false, animated: false)
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing && contentListViewModel.isEditAvailable {
			showEditAlertForItem(at: indexPath)
		} else {
			contentListViewModel.didSelectItem?(indexPath.row)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func tableView(
		_ tableView: UITableView,
		trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {

		var actions: [UIContextualAction] = []

		if contentListViewModel.isDeleteAvailable {
			actions.append(
				UIContextualAction(style: .destructive, title: L10n.Action.Title.delete) { (_, _, handler) in
					self.showDeletionAlertForItem(at: indexPath)
					handler(true)
				}
			)
		}

		if contentListViewModel.isEditAvailable {
			actions.append(
				UIContextualAction(style: .normal, title: L10n.Action.Title.rename) { (_, _, handler) in
					self.showEditAlertForItem(at: indexPath)
					handler(true)
				}
			)
		}

		return UISwipeActionsConfiguration(actions: actions)
	}

}

// MARK: - Private Methods

private extension ContentListViewController {

	func setupViewModel() {
		tableView.dataSource = contentListViewModel
		if contentListViewModel.isChangesProvider {
			contentListViewModel.changesHandler = { [weak self] changes in
				self?.handleChanges(changes)
			}
		}
	}

	func initialSetup() {
		title = contentListViewModel.listTitle
		navigationItem.rightBarButtonItem = editButtonItem

		tableView.dataSource = contentListViewModel
		tableView.tableFooterView = UIView()
		tableView.allowsSelectionDuringEditing = true

		setupToolBar()
	}

	func setupToolBar() {
		let items: [UIBarButtonItem] = [
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertToCreateNewItem)),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		]

		setToolbarItems(items, animated: true)
	}

	// MARK: - Alerts

	func showDeletionAlertForItem(at indexPath: IndexPath) {

		let title = L10n.Alert.Title.delete(contentListViewModel.nameOfItems)
		let message = L10n.Alert.Message.delete(contentListViewModel.item(at: indexPath.row))

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: L10n.Action.Title.cancel, style: .cancel))
		alert.addAction(UIAlertAction(title: L10n.Action.Title.delete, style: .destructive) { _ in
			self.contentListViewModel.deleteItem(at: indexPath.row)
			if !self.contentListViewModel.isChangesProvider {
				self.tableView.deleteRows(at: [indexPath], with: .none)
			}
		})

		present(alert, animated: true)
	}

	func showEditAlertForItem(at indexPath: IndexPath) {

		let text = contentListViewModel.item(at: indexPath.row)

		let title = L10n.Alert.Title.edit(contentListViewModel.nameOfItems)

		inputTextAlertController.showInputTextAlert(
			withTitle: title,
			actionTitle: L10n.Action.Title.save,
			textFieldPlaceholder: text) { [unowned self] (resultText) in

				self.contentListViewModel.updateItem(at: indexPath.row, with: resultText)
				if !self.contentListViewModel.isChangesProvider {
					self.tableView.reloadRows(at: [indexPath], with: .automatic)
				}
		}
	}

	@objc
	func showAlertToCreateNewItem() {

		let title = L10n.Alert.Title.createNew(contentListViewModel.nameOfItems)

		inputTextAlertController.showInputTextAlert(
			withTitle: title,
			actionTitle: L10n.Action.Title.create) { [unowned self] (resultText) in

				let numberOfItems = self.contentListViewModel.numberOfItems()

				self.contentListViewModel.createNewItem(with: resultText)

				if !self.contentListViewModel.isChangesProvider {
					let newItemIndexPath = IndexPath(row: numberOfItems, section: 0)
					self.tableView.insertRows(at: [newItemIndexPath], with: .automatic)
					self.tableView.scrollToRow(at: newItemIndexPath, at: .none, animated: true)
				}
		}
	}

	func handleChanges(_ changes: [Change]) {
		tableView.performBatchUpdates({
			changes.forEach { change in
				switch change {
				case .update(let index):
					tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
				case .insert(let index):
					tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
				case .delete(let index):
					tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
				case .move(let fromIndex, let toIndex):
					tableView.moveRow(at: IndexPath(row: fromIndex, section: 0), to: IndexPath(row: toIndex, section: 0))
				}
			}
		})
	}

}
