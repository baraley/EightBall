//
//  AnswerSetsModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol AnswerSetsModelObserver: class {

	func answerSetsModel(_ model: AnswerSetsModel, changesDidHappen changes: [Change<AnswerSet>])

}

final class AnswerSetsModel {

	private let coreDataModelService: CoreDataModelService<ManagedAnswerSet, AnswerSet>

	init(coreDataModelService: CoreDataModelService<ManagedAnswerSet, AnswerSet>) {
		self.coreDataModelService = coreDataModelService
		self.coreDataModelService.changeHandler = {[weak self] (changes) in
			self?.handleChanges(changes)
		}
	}

	// MARK: - Public

	func loadAnswerSets() {
		coreDataModelService.loadModels()
	}

	func numberOfAnswerSets() -> Int {
		return coreDataModelService.numberOfModels()
	}

	func answerSet(at index: Int) -> AnswerSet {
		return coreDataModelService.model(at: index)
	}

	func save(_ answerSet: AnswerSet) {
		coreDataModelService.upsert(answerSet)
	}

	func deleteAnswerSet(at index: Int) {
		coreDataModelService.deleteModel(at: index)
	}

	// MARK: - Observation

	private var observations: [ObjectIdentifier: Observation] = [:]

	func addObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	// MARK: - Private

	private func handleChanges(_ changes: [Change<AnswerSet>]) {

		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				DispatchQueue.main.async {
					observer.answerSetsModel(self, changesDidHappen: changes)
				}

			} else {
				observations.removeValue(forKey: id)
			}
		}
	}

}

private extension AnswerSetsModel {

	struct Observation {
        weak var observer: AnswerSetsModelObserver?
    }

}
