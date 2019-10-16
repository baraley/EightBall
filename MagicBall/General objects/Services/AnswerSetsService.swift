//
//  AnswerSetsService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

final class AnswerSetsService: AnswerSetsServiceProtocol {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
		assignToContextNotifications()
	}

	var answersSetsDidChange: (([AnswerSet]) -> Void)?

	private var loadedAnswerSets: [String: ManagedAnswerSet] = [:]

	func loadAnswerSets() {
		context.perform { [weak self] in
			guard let self = self else { return }

			let managedAnswerSets = (try? self.context.fetch(self.answerSetsRequest)) ?? []

			self.loadedAnswerSets = Dictionary(uniqueKeysWithValues: managedAnswerSets.map { ($0.id, $0)})

			let answerSets = managedAnswerSets.map { $0.toAnswerSet()}
			self.answersSetsDidChange?(answerSets)
		}
	}

	func upsert(_ answerSet: AnswerSet) {
		context.perform { [weak self] in
			guard let self = self else { return }

			let managedAnswerSet = self.loadedAnswerSets[answerSet.id] ?? ManagedAnswerSet(context: self.context)
			managedAnswerSet.populateWith(answerSet)
			self.context.saveIfNeeds()
		}
	}

	func delete(_ answerSet: AnswerSet) {
		context.perform { [weak self] in
			guard let self = self else { return }

			if let managedAnswerSet = self.loadedAnswerSets.removeValue(forKey: answerSet.id) {
				self.context.delete(managedAnswerSet)
				self.context.saveIfNeeds()
			}
		}
	}

	private var answerSetsRequest: NSFetchRequest<ManagedAnswerSet> {
		let request = ManagedAnswerSet.makeRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(ManagedAnswerSet.dateCreated), ascending: true)
		]
		return request
	}

	private func assignToContextNotifications() {
		let name = Notification.Name.NSManagedObjectContextDidSave
		let selector = #selector(contextObjectsDidChange(_:))

		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
	}

	@objc private func contextObjectsDidChange(_ notification: Notification) {
		loadAnswerSets()
	}

}
