//
//  AnswersContentListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellID = String(describing: UITableViewCell.self)

final class AnswersContentListViewModel: NSObject, ContentListViewModel {

	private var answers: [Answer] {
		didSet {
			answersDidChange()
		}
	}
	private let answerSet: AnswerSet
	private let answerSetsModel: AnswerSetsModel

	init(answerSet: AnswerSet, answerSetsModel: AnswerSetsModel) {
		self.answers = answerSet.answers
		self.answerSet = answerSet
		self.answerSetsModel = answerSetsModel
		self.listTitle = answerSet.name
		super.init()
	}

	// MARK: - EditableListViewModel

	let listTitle: String
	let nameOfItems: String = L10n.EditableItems.Name.answers
	var didSelectItem: ((Int) -> Void)?

	let isChangesProvider: Bool = false
	var changesHandler: (([ContentListViewController.Change]) -> Void)?

	let isCreationAvailable: Bool = true
	let isEditAvailable: Bool = true
	let isDeleteAvailable: Bool = true

	func numberOfItems() -> Int {
		return answers.count
	}

	func item(at index: Int) -> String {
		return answers[index].text
	}

	func updateItem(at index: Int, with text: String) {
		answers[index] = Answer(text: text)
	}

	func createNewItem(with text: String) {
		answers.append(Answer(text: text))
	}

	func deleteItem(at index: Int) {
		answers.remove(at: index)
	}

	// MARK: - Private Methods

	private func answersDidChange() {
		var updatedAnswerSet = answerSet
		updatedAnswerSet.answers = answers
		answerSetsModel.save(updatedAnswerSet)
	}
}

// MARK: - UITableViewDataSource

extension AnswersContentListViewModel {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfItems()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: UITableViewCell

		if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
			cell = dequeuedCell
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
		}

		cell.textLabel?.text = answers[indexPath.row].text

		return cell
	}
}
