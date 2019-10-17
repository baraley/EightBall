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

	private var presentableAnswers: [PresentableAnswer] {
		didSet {
			answersDidChange()
		}
	}
	private let answerSet: PresentableAnswerSet
	private let answerSetsModel: AnswerSetsModel

	init(answerSet: PresentableAnswerSet, answerSetsModel: AnswerSetsModel) {
		self.presentableAnswers = answerSet.answers
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
		return presentableAnswers.count
	}

	func item(at index: Int) -> String {
		return presentableAnswers[index].text
	}

	func updateItem(at index: Int, with text: String) {
		presentableAnswers[index] = PresentableAnswer(text: text)
	}

	func createNewItem(with text: String) {
		presentableAnswers.append(PresentableAnswer(text: text))
	}

	func deleteItem(at index: Int) {
		presentableAnswers.remove(at: index)
	}

	// MARK: - Private Methods

	private func answersDidChange() {
		let answers = presentableAnswers.map { Answer(from: $0)}
		let updatedAnswerSet = AnswerSet(id: answerSet.id, name: answerSet.name, answers: answers)
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

		cell.textLabel?.text = presentableAnswers[indexPath.row].text

		return cell
	}

}
