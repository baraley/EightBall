//
//  CoreDataModelService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 18.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

enum Change<T> {

	case insert(T, Int)
	case delete(T, Int)
	case move(T, Int, Int)
	case update(T, Int)

}

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

	var changeHandler: (([Change<Model>]) -> Void)?
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

		return toModelConverter(managedModel)
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

		let model = toModelConverter(managedModel)

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
			self.changeHandler?(changes)
		}
	}

}
