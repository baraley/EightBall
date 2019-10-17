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
		case network, answerSet(Int)
	}

	var answerSource: Source = .network

	private let answerSetsModel: AnswerSetsModel
	private let networkAnswerService: NetworkAnswerService
	private let historyAnswersModel: HistoryAnswersModel

	init(
		answerSetsModel: AnswerSetsModel,
		networkAnswerService: NetworkAnswerService,
		historyAnswersModel: HistoryAnswersModel
	) {

		self.answerSetsModel = answerSetsModel
		self.networkAnswerService = networkAnswerService
		self.historyAnswersModel = historyAnswersModel

		answerSetsModel.addObserver(self)
		answerSetsModel.loadAnswerSets()
	}

	private var answerSets: [AnswerSet] = []

	var answerSetsDidChangeHandler: (() -> Void)?
	var answerLoadingErrorHandler: ((String) -> Void)?

	func loadAnswerSets() {
		answerSets = answerSetsModel.notEmptyAnswerSets()
	}

	func numberOfAnswerSets() -> Int {
		return answerSets.count
	}

	func answerSet(at index: Int) -> AnswerSet {
		return answerSets[index]
	}

	func loadAnswer(_ completionHandler: @escaping (Answer?) -> Void) {
		switch answerSource {
		case .network:
			loadAnswerFromNetwork(with: completionHandler)

		case .answerSet(let index):
			if let answer = answerSets[index].answers.randomElement() {
				historyAnswersModel.save(HistoryAnswer(text: answer.text))
				completionHandler(answer)
			}
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

extension AnswerSourcesModel: AnswerSetsModelObserver {

	func answerSetsModelDidChangeAnswerSets(_ model: AnswerSetsModel) {
		loadAnswerSets()
		answerSetsDidChangeHandler?()
	}

}
