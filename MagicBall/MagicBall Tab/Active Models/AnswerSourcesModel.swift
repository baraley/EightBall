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

protocol AnswerSourcesService: class {

	var changesHandler: (([Change<AnswerSet>]) -> Void)? { get set }

	func loadAnswerSources()
	func numberOfAnswerSources() -> Int
	func answerSource(at index: Int) -> AnswerSet

}

final class AnswerSourcesModel {

	typealias CompletionHandler = ((Result<Answer, NetworkError>) -> Void)

	enum Source {
		case network, answerSet(AnswerSet)
	}

	var answerSource: Source = .network

	private let answerSourcesService: AnswerSourcesService
	private let networkAnswerService: NetworkAnswerService
	private let historyAnswersModel: HistoryAnswersModel

	init(
		answerSourcesService: AnswerSourcesService,
		networkAnswerService: NetworkAnswerService,
		historyAnswersModel: HistoryAnswersModel
	) {

		self.answerSourcesService = answerSourcesService
		self.networkAnswerService = networkAnswerService
		self.historyAnswersModel = historyAnswersModel

		self.answerSourcesService.changesHandler = {[weak self] (changes) in
			self?.handleChanges(changes)
		}
	}

	var answerSetsDidChangeHandler: (() -> Void)?
	var answerLoadingErrorHandler: ((String) -> Void)?

	func loadAnswerSets() {
		answerSourcesService.loadAnswerSources()
	}

	func numberOfAnswerSets() -> Int {
		return answerSourcesService.numberOfAnswerSources()
	}

	func answerSet(at index: Int) -> AnswerSet {
		return answerSourcesService.answerSource(at: index)
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
