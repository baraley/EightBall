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

	init(persistentContainer: PersistentContainer) {
		self.context = persistentContainer.newBackgroundContext()
	}

//	func createDefaultAnswersSetsIfNeeds() {
//		guard PersistentContainer.isPersistenceStoreEmpty() else { return }
//
//		let name = DefaultResourceName.rudeAnswers.rawValue
//		let rudeAnswers = FileManager.default.loadContentFromBundle(withName: name) as [String]
//		let answers = rudeAnswers.map { Answer(text: $0) }
//
//		let answerSets = [AnswerSet(name: name, answers: answers)]
//
//		save(answerSets)
//	}

	private var loadedAnswerSets: [String: ManagedAnswerSet] = [:]

	func loadAnswerSets(_ completionHandler: @escaping ([AnswerSet]) -> Void) {
		context.perform { [weak self] in
			guard let self = self else { return }

			let managedAnswerSets = (try? self.context.fetch(self.answerSetsRequest)) ?? []

			self.loadedAnswerSets = Dictionary(uniqueKeysWithValues: managedAnswerSets.map { ($0.id, $0)})

			let answerSets = managedAnswerSets.map { $0.toAnswerSet()}
			completionHandler(answerSets)
		}
	}

	func update(_ answerSet: AnswerSet) {
		context.perform { [weak self] in
			guard let self = self else { return }

			if let managedAnswerSet = self.loadedAnswerSets[answerSet.id] {
				managedAnswerSet.populateWith(answerSet)
			}
			self.context.saveIfNeeds()
		}
	}

	func appendNew(_ answerSet: AnswerSet) {
		context.perform { [weak self] in
			guard let self = self else { return }
			let managedAnswerSet = ManagedAnswerSet(context: self.context)
			managedAnswerSet.populateWith(answerSet)

			self.loadedAnswerSets[managedAnswerSet.id] = managedAnswerSet

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

}
