//
//  AnswerSetsContentListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellID = String(describing: UITableViewCell.self)

final class AnswerSetsContentListViewModel: NSObject, ContentListViewModel {

	private let answerSetsModel: AnswerSetsModel

	init(answerSetsModel: AnswerSetsModel) {
		self.answerSetsModel = answerSetsModel

		super.init()

		answerSetsModel.addObserver(self)
	}

	// MARK: - EditableListViewModel

	let listTitle: String = L10n.NavigationBar.Title.answerSets
	let nameOfItems: String = L10n.EditableItems.Name.answerSets
	var didSelectItem: ((Int) -> Void)?

	let isChangesProvider: Bool = true
	var changesHandler: (([ContentListViewController.Change]) -> Void)?

	let isCreationAvailable: Bool = true
	let isEditAvailable: Bool = true
	let isDeleteAvailable: Bool = true

	func numberOfItems() -> Int {
		return answerSetsModel.numberOfAnswerSets()
	}

	func item(at index: Int) -> String {
		let answerSet = answerSetsModel.answerSet(at: index)
		return PresentableAnswerSet(answerSet).name
	}

	func updateItem(at index: Int, with text: String) {
		var answerSet = answerSetsModel.answerSet(at: index)
		answerSet.name = text
		answerSetsModel.save(answerSet)
	}

	func createNewItem(with text: String) {
		let answerSet = AnswerSet(name: text)
		answerSetsModel.save(answerSet)
	}

	func deleteItem(at index: Int) {
		answerSetsModel.deleteAnswerSet(at: index)
	}
}

extension AnswerSetsContentListViewModel: AnswerSetsModelObserver {

	func answerSetsModel(_ model: AnswerSetsModel, changesDidHappen changes: [Change<AnswerSet>]) {
		var viewChanges: [ContentListViewController.Change] = []

		changes.forEach { change in
			switch change {
			case .update(_, let index):
				viewChanges.append(.update(index))
			case .insert(_, let index):
				viewChanges.append(.insert(index))
			case .delete(_, let index):
				viewChanges.append(.delete(index))
			case .move(_, let fromIndex, let toIndex):
				viewChanges.append(.move(fromIndex, toIndex))
			}
		}
		changesHandler?(viewChanges)
	}
}

// MARK: - UITableViewDataSource

extension AnswerSetsContentListViewModel {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfItems()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: UITableViewCell

		if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
			cell = dequeuedCell
		} else {
			cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
			cell.accessoryType = .disclosureIndicator
		}

		let answerSet = answerSetsModel.answerSet(at: indexPath.row)

		cell.textLabel?.text = answerSet.name
		cell.detailTextLabel?.text = String(answerSet.answers.count)

		return cell
	}
}
