//
//  AnswerSetsEditableListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellID = String(describing: UITableViewCell.self)

final class AnswerSetsEditableListViewModel: NSObject, EditableListViewModel {

	private let answerSetsModel: AnswerSetsModel

	init(answerSetsModel: AnswerSetsModel) {
		self.answerSetsModel = answerSetsModel

		super.init()
	}

	// MARK: - EditableListViewModel

	var listTitle: String = L10n.NavigationBar.Title.answerSets
	var nameOfItems: String = L10n.EditableItems.Name.answerSets
	var didSelectItem: ((Int) -> Void)?

	func numberOfItems() -> Int {
		return answerSetsModel.numberOfAnswerSets()
	}

	func item(at index: Int) -> String {
		answerSetsModel.answerSet(at: index).toPresentableAnswerSet().name
	}

	func updateItem(at index: Int, with text: String) {
		var answerSet = answerSetsModel.answerSet(at: index)
		answerSet.name = text
		answerSetsModel.save(answerSet)
	}

	func createNewItem(with text: String) {
		let answerSet = AnswerSet(name: text, answers: [])
		answerSetsModel.save(answerSet)
	}

	func deleteItem(at index: Int) {
		answerSetsModel.deleteAnswerSet(at: index)
	}

}

// MARK: - UITableViewDataSource

extension AnswerSetsEditableListViewModel {

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
