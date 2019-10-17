//
//  HistoryAnswerContentListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellID = String(describing: UITableViewCell.self)

final class HistoryAnswerContentListViewModel: NSObject, ContentListViewModel {

	private let historyAnswersModel: HistoryAnswersModel

	init(historyAnswersModel: HistoryAnswersModel) {
		self.historyAnswersModel = historyAnswersModel
		historyAnswersModel.loadHistoryAnswers()
		super.init()

		historyAnswersModel.addObserver(self)
	}

	var listTitle: String = L10n.NavigationBar.Title.history
	var nameOfItems: String = L10n.EditableItems.Name.historyAnswers
	var didSelectItem: ((Int) -> Void)?

	var isChangesProvider: Bool = true
	var changesHandler: (([ContentListViewController.Change]) -> Void)?

	var isCreationAvailable: Bool = false
	var isEditAvailable: Bool = false
	var isDeleteAvailable: Bool = true

	func numberOfItems() -> Int {
		return historyAnswersModel.numberOfHistoryAnswers()
	}

	func item(at index: Int) -> String {
		return historyAnswersModel.historyAnswer(at: index).text
	}

	func updateItem(at index: Int, with text: String) { }

	func createNewItem(with text: String) { }

	func deleteItem(at index: Int) {
		historyAnswersModel.deleteHistoryAnswer(at: index)
	}

}

// MARK: - UITableViewDataSource

extension HistoryAnswerContentListViewModel {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfItems()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: UITableViewCell

		if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
			cell = dequeuedCell
		} else {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
		}

		let historyAnswer = historyAnswersModel.historyAnswer(at: indexPath.row)
		let presentableHistoryAnswer = PresentableHistoryAnswer(historyAnswer: historyAnswer)

		cell.textLabel?.text = presentableHistoryAnswer.text
		cell.detailTextLabel?.text = presentableHistoryAnswer.dateText

		return cell
	}

}

extension HistoryAnswerContentListViewModel: HistoryAnswerModelObserver {

	func historyAnswerModel(_ model: HistoryAnswersModel, changesDidHappen changes: [HistoryAnswersModel.Change]) {
		var viewChanges: [ContentListViewController.Change] = []

		changes.forEach { change in
			switch change {
			case .insert(_, let index):
				viewChanges.append(.insert(index))
			case .delete(_, let index):
				viewChanges.append(.delete(index))
			}
		}
		changesHandler?(viewChanges)
	}

}
