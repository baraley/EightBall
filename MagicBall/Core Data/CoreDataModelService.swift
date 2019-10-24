//
//  CoreDataModelService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 18.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

protocol Populatable {

	associatedtype Source

	func populateWith(_ source: Source)

}

protocol Identifiable {

	var id: String { get }

}

final class CoreDataModelService<ManagedModel: NSManagedObject, Model>: NSObject, NSFetchedResultsControllerDelegate
where ManagedModel: Populatable & Identifiable, Model: Identifiable, ManagedModel.Source == Model {

	private let context: NSManagedObjectContext
	private let fetchRequest: NSFetchRequest<ManagedModel>
	private let toModelConverter: (ManagedModel) -> Model

	init(
		context: NSManagedObjectContext,
		fetchRequest: NSFetchRequest<ManagedModel>,
		toModelConverter: @escaping (ManagedModel) -> Model
	) {
		self.context = context
		self.fetchRequest = fetchRequest
		self.toModelConverter = toModelConverter

		super.init()

		fetchedResultsController.delegate = self
	}

	var changesHandler: (([Change<Model>]) -> Void)?
	private var changes: [Change<Model>] = []

	private lazy var fetchedResultsController = NSFetchedResultsController(
		fetchRequest: fetchRequest,
		managedObjectContext: context,
		sectionNameKeyPath: nil,
		cacheName: nil
	)

	// MARK: - Public methods

	func loadModels() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	func numberOfModels() -> Int {
		return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
	}

	func model(at index: Int) -> Model {
		let managedModel = fetchedResultsController.object(at: IndexPath(row: index, section: 0))

		return convertToModel(managedModel)
	}

	func upsert(_ model: Model) {
		performInContext {
			let request = self.fetchRequestForManagedModel(with: model.id)
			let managedModel = (try? request.execute().first) ?? ManagedModel(context: self.context)
			managedModel.populateWith(model)
			self.context.saveIfNeeds()
		}
	}

	func deleteModel(at index: Int) {
		performInContext {
			let managedModel = self.fetchedResultsController.object(at: IndexPath(row: index, section: 0))
			self.context.delete(managedModel)
			self.context.saveIfNeeds()
		}
	}

	// MARK: - Private methods

	private func fetchRequestForManagedModel(with id: String) -> NSFetchRequest<ManagedModel> {
		let request = NSFetchRequest(entityName: fetchRequest.entityName ?? "") as NSFetchRequest<ManagedModel>
		request.predicate = NSPredicate(format: "\(#keyPath(ManagedHistoryAnswer.id)) == %@", id)
		request.fetchLimit = 1

		return request
	}

	private func performInContext(_ closure: @escaping () -> Void) {
		context.perform { [weak self] in
			if self == nil { return }

			closure()
		}
	}

	func convertToModel(_ managedModel: ManagedModel) -> Model {
		var model: Model!

		context.performAndWait {
			model = toModelConverter(managedModel)
		}

		return model
	}

	// MARK: - NSFetchedResultsController

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
		guard
			let index = indexPath?.row ?? newIndexPath?.row,
			let managedModel = anObject as? ManagedModel
			else { return }

		let model = convertToModel(managedModel)

		switch type {
		case .insert:
			changes.append(.insert(model, index))

		case .delete:
			changes.append(.delete(model, index))

		case .move:
			if let newIndex = newIndexPath?.row {
				changes.append(.move(model, index, newIndex))
			}
		case .update:
			changes.append(.update(model, index))

		default:
			fatalError("Can't handle type NSFetchedResultsChangeType: \(type)")
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if !changes.isEmpty {
			self.changesHandler?(changes)
		}
	}

}

extension CoreDataModelService: AnswerSetsService where ManagedModel == ManagedAnswerSet {

	func loadAnswerSets() {
		loadModels()
	}

	func numberOfAnswerSets() -> Int {
		return numberOfModels()
	}

	func answerSet(at index: Int) -> AnswerSet {
		return model(at: index)
	}

	func deleteAnswerSet(at index: Int) {
		deleteModel(at: index)
	}

}

extension CoreDataModelService: HistoryAnswersService where ManagedModel == ManagedHistoryAnswer {

	func loadHistoryAnswers() {
		loadModels()
	}

	func numberOfHistoryAnswers() -> Int {
		return numberOfModels()
	}

	func historyAnswer(at index: Int) -> HistoryAnswer {
		return model(at: index)
	}

	func deleteHistoryAnswer(at index: Int) {
		deleteModel(at: index)
	}

}

extension CoreDataModelService: AnswerSourcesService where ManagedModel == ManagedAnswerSet {

	func loadAnswerSources() {
		loadModels()
	}

	func numberOfAnswerSources() -> Int {
		return numberOfModels()
	}

	func answerSource(at index: Int) -> AnswerSet {
		return model(at: index)
	}

}
