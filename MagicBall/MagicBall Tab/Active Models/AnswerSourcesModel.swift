//
//  AnswerSourcesModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol NetworkAnswerService {

	func loadAnswer(with completionHandler: @escaping AnswerSourcesModel.CompletionHandler)

}

final class AnswerSourcesModel {

	typealias CompletionHandler = ((Result<Answer, NetworkError>) -> Void)

	enum Source {
		case network, answerSet(AnswerSet)
	}

	var answerSource: Source = .network

	private let coreDataModelService: CoreDataModelService<ManagedAnswerSet, AnswerSet>
	private let networkAnswerService: NetworkAnswerService
	private let historyAnswersModel: HistoryAnswersModel

	init(
		coreDataModelService: CoreDataModelService<ManagedAnswerSet, AnswerSet>,
		networkAnswerService: NetworkAnswerService,
		historyAnswersModel: HistoryAnswersModel
	) {

		self.coreDataModelService = coreDataModelService
		self.networkAnswerService = networkAnswerService
		self.historyAnswersModel = historyAnswersModel

		self.coreDataModelService.changeHandler = {[weak self] (changes) in
			self?.handleChanges(changes)
		}
	}

	var answerSetsDidChangeHandler: (() -> Void)?
	var answerLoadingErrorHandler: ((String) -> Void)?

	func loadAnswerSets() {
		coreDataModelService.loadModels()
	}

	func numberOfAnswerSets() -> Int {
		return coreDataModelService.numberOfModels()
	}

	func answerSet(at index: Int) -> AnswerSet {
		return coreDataModelService.model(at: index)
	}

	func loadAnswer(_ completionHandler: @escaping (Answer?) -> Void) {
		switch answerSource {
		case .network:
			loadAnswerFromNetwork(with: completionHandler)

		case .answerSet(let sourceAnswerSet):
			if let answer = sourceAnswerSet.answers.randomElement() {
				historyAnswersModel.save(HistoryAnswer(text: answer.text))
				completionHandler(answer)
			}
		}
	}

	// MARK: - Private

	private func handleChanges(_ changes: [Change<AnswerSet>]) {
		DispatchQueue.main.async {
			self.answerSetsDidChangeHandler?()
		}
	}

	private func loadAnswerFromNetwork(with completionHandler: @escaping (Answer?) -> Void) {
		networkAnswerService.loadAnswer { [weak self] (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let answer):
					self?.historyAnswersModel.save(HistoryAnswer(text: answer.text))
					completionHandler(answer)

				case .failure(let error):
					let errorMessage = error.errorDescription
					self?.answerLoadingErrorHandler?(errorMessage)

					completionHandler(nil)
				}
			}
		}
	}

}
