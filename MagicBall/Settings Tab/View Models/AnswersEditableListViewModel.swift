//
//  AnswersEditableListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellIdentifier = "AnswerCell"

final class AnswersEditableListViewModel: NSObject, EditableListViewModel {

	private(set) var answers: [String] {
		didSet {
			answersDidChangeHandler(answers)
		}
	}
	private let answersDidChangeHandler: (([String]) -> Void)

	init(answerSet: AnswerSet, answersDidChangeHandler: @escaping (([String]) -> Void)) {
		self.answers = answerSet.answers
		self.answersDidChangeHandler = answersDidChangeHandler
		self.listTitle = answerSet.name
		super.init()
	}

	// MARK: - EditableListViewModel -

	var listTitle: String

	var nameOfItems: String = L10n.EditableItems.Name.answers

	var didSelectItem: ((Int) -> Void)?

	func numberOfItems() -> Int {
		return answers.count
	}

	func item(at index: Int) -> String {
		return answers[index]
	}

	func updateItem(at index: Int, with text: String) {
		answers[index] = text
	}

	func createNewItem(with text: String) {
		answers.append(text)
	}

	func deleteItem(at index: Int) {
		answers.remove(at: index)
	}
}

// MARK: - UITableViewDataSource -

extension AnswersEditableListViewModel {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfItems()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

		cell.textLabel?.text = answers[indexPath.row]

		return cell
	}

}
