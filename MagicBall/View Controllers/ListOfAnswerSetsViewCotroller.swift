//
//  ListOfAnswerSetsViewCotroller.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/14/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class ListOfAnswerSetsViewCotroller: UITableViewController, SegueHandlerType {

	var answerSetsStore: AnswerSetsStore!

	private lazy var inputTextAlerController: InputTextAlerController = .init(presentingViewController: self)

	// MARK: - Life cycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.rightBarButtonItem = editButtonItem
		navigationController?.setToolbarHidden(false, animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		navigationController?.setToolbarHidden(true, animated: true)
	}

	// MARK: - Navigation

	enum SegueIdentifier: String {
		case answers
	}

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		return !isEditing
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard case .answers = segueIdentifier(for: segue),
            let viewController = segue.destination as? AnswerSetTableViewCotroller
        else { return }

		if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
			viewController.answerSet = answerSetsStore.answerSets[indexPathForSelectedRow.row]
			viewController.answerSetDidChangeHandler = { changedAnswerSet in

				self.answerSetsStore.save(changedAnswerSet)

				self.tableView.reloadRows(at: [indexPathForSelectedRow], with: .automatic)
			}
		}
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answerSetsStore.answerSets.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = String(describing: UITableViewCell.self)

		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

		let answerSet = answerSetsStore.answerSets[indexPath.row]
		cell.textLabel?.text = answerSet.name
		cell.detailTextLabel?.text = String(answerSet.answers.count)

		return cell
	}

	override func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {

		if editingStyle == .delete {
			let answerSet = answerSetsStore.answerSets[indexPath.row]

			if answerSet.answers.isEmpty {
				answerSetsStore.deleteAnswerSet(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .none)
			} else {
				showDeletingAlertForAnswerSet(at: indexPath)
			}
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if isEditing {
			editAnswerSet(at: indexPath)
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	override func tableView(
		_ tableView: UITableView,
		editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

		return .delete
	}

}

// MARK: - Private

private extension ListOfAnswerSetsViewCotroller {

	func showDeletingAlertForAnswerSet(at indexPath: IndexPath) {
		let answerSet = answerSetsStore.answerSets[indexPath.row]
		let numberOfAnswers = answerSet.answers.count

		let message = L10n.Alert.Message.deleteAnswerSet(numberOfAnswers)

		let alert = UIAlertController(
			title: L10n.Alert.Title.deleteAnswerSet, message: message, preferredStyle: .alert
		)

		alert.addAction(.init(title: L10n.Action.Title.cancel, style: .cancel, handler: nil))

		alert.addAction(.init(title: L10n.Action.Title.delete, style: .destructive) {  _ in

			self.answerSetsStore.deleteAnswerSet(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .none)
			})

		present(alert, animated: true)
	}

	func editAnswerSet(at indexPath: IndexPath) {

		let placeholder = self.answerSetsStore.answerSets[indexPath.row].name

		inputTextAlerController.showInputTextAlert(
			with: L10n.Alert.Title.editAnswerSet,
			actionTitle: L10n.Action.Title.save,
			textFieldPlaceholder: placeholder) { [unowned self] (name) in

				var answerSet = self.answerSetsStore.answerSets[indexPath.row]
				answerSet.name = name
				self.answerSetsStore.save(answerSet)
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}

	@IBAction func acceptTextForNewAnswerSet() {

		inputTextAlerController.showInputTextAlert(
			with: L10n.Alert.Title.newAnswerSet,
			actionTitle: L10n.Action.Title.add) { [unowned self] (name) in

				let numberOfAnswerSets = self.answerSetsStore.answerSets.count

				let newAnswerSet = AnswerSet(name: name, answers: [])
				self.answerSetsStore.save(newAnswerSet)

				let newAnswerSetIndexPath = IndexPath(row: numberOfAnswerSets, section: 0)
				self.tableView.insertRows(at: [newAnswerSetIndexPath], with: .automatic)
				self.tableView.scrollToRow(at: newAnswerSetIndexPath, at: .none, animated: true)
		}
	}

}
