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

		historyAnswersModel.historyAnswersChangesHandler = { [weak self] changes in
			self?.handleChanges(changes)
		}
	}

	let listTitle: String = L10n.NavigationBar.Title.history
	let nameOfItems: String = L10n.EditableItems.Name.historyAnswers

	var didSelectItem: ((Int) -> Void)?

	let isChangesProvider: Bool = true
	var changesHandler: (([ContentListViewController.Change]) -> Void)?

	let isDeleteAvailable: Bool = true

	func numberOfItems() -> Int {
		return historyAnswersModel.numberOfHistoryAnswers()
	}

	func item(at index: Int) -> String {
		return historyAnswersModel.historyAnswer(at: index).text
	}

	func deleteItem(at index: Int) {
		historyAnswersModel.deleteHistoryAnswer(at: index)
	}

	private func handleChanges(_ changes: [Change<HistoryAnswer>]) {
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
		let presentableHistoryAnswer = PresentableHistoryAnswer(historyAnswer)

		cell.textLabel?.text = presentableHistoryAnswer.text
		cell.detailTextLabel?.text = presentableHistoryAnswer.dateText

		return cell
	}
}
