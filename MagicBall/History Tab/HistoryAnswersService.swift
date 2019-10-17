//
//  HistoryAnswersService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

final class HistoryAnswersService: NSObject {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
		super.init()

		fetchedResultsController.delegate = self
	}

	var historyAnswerDidChangeHandler: (([HistoryAnswersModel.Change]) -> Void)?
	private var changes: [HistoryAnswersModel.Change] = []

	private lazy var fetchedResultsController = NSFetchedResultsController(
		fetchRequest: managedHistoryAnswersRequest,
		managedObjectContext: context,
		sectionNameKeyPath: nil,
		cacheName: nil
	)

	private var managedHistoryAnswersRequest: NSFetchRequest<ManagedHistoryAnswer> {
		let fetchRequest = ManagedHistoryAnswer.makeRequest()
		fetchRequest.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(ManagedHistoryAnswer.dateCreated), ascending: false)
		]

		return fetchRequest
	}

	private func performInContext(_ closure: @escaping () -> Void) {
		context.perform { [weak self] in
			if self == nil { return }

			closure()
		}
	}

}

extension HistoryAnswersService: HistoryAnswerServiceProtocol {

	var numberOfHistoryAnswers: Int {
		fetchedResultsController.sections?.first?.numberOfObjects ?? 0
	}

	func loadHistoryAnswers() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	func historyAnswer(at index: Int) -> HistoryAnswer {
		return fetchedResultsController.object(at: IndexPath(row: index, section: 0)).toHistoryAnswer()
	}

	func insert(_ historyAnswer: HistoryAnswer) {
		performInContext {
			let managedHistoryAnswer =  ManagedHistoryAnswer(context: self.context)
			managedHistoryAnswer.populateWith(historyAnswer)
			self.context.saveIfNeeds()
		}
	}

	func deleteHistoryAnswer(at index: Int) {
		performInContext {
			let managedHistoryAnswer = self.fetchedResultsController.object(at: IndexPath(row: index, section: 0))
			self.context.delete(managedHistoryAnswer)
			self.context.saveIfNeeds()
		}
	}

	func clearHistory() {
		performInContext {
			if let managedHistoryAnswers = self.fetchedResultsController.fetchedObjects {
				managedHistoryAnswers.forEach {
					self.context.delete($0)
				}
			}
			self.context.saveIfNeeds()
		}
	}

}

extension HistoryAnswersService: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		changes = []
	}

	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange anObject: Any,
		at indexPath: IndexPath?,
		for type: NSFetchedResultsChangeType,
		newIndexPath: IndexPath?
	) {

		guard let index = indexPath?.row, let managedHistoryAnswer = anObject as? ManagedHistoryAnswer else { return }

		switch type {
		case .insert: changes.append(.insert(managedHistoryAnswer.toHistoryAnswer(), index))
		case .delete: changes.append(.delete(managedHistoryAnswer.toHistoryAnswer(), index))
		default:
			fatalError("Can't handle type NSFetchedResultsChangeType: \(type)")
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if !changes.isEmpty {
			historyAnswerDidChangeHandler?(changes)
		}
	}
}
