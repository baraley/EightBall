//
//  AnswerSourcesModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class AnswerSourcesModel {

	enum Source {
		case network, answerSet(Int)
	}

	var answerSource: Source = .network

	private let answerSetsModel: AnswerSetsModel
	private let networkAnswerModel: NetworkAnswerModel

	init(answerSetsModel: AnswerSetsModel, networkAnswerModel: NetworkAnswerModel) {
		self.answerSetsModel = answerSetsModel
		self.networkAnswerModel = networkAnswerModel

		answerSetsModel.addObserver(self)
	}

	private var answerSets: [AnswerSet] = []

	var answerSetsDidChangeHandler: (() -> Void)?

	var answerLoadingErrorHandler: ((String) -> Void)?

	func loadAnswerSets() {
		let notEmptyAnswerSets = answerSetsModel.loadAnswerSets().filter { !$0.answers.isEmpty }
		answerSets = notEmptyAnswerSets
	}

	func numberOfAnswerSets() -> Int {
		return answerSets.count
	}

	func answerSet(at index: Int) -> AnswerSet {
		return answerSets[index]
	}

	func loadAnswer(_ completionHandler: @escaping (String?) -> Void) {
		switch answerSource {
		case .network:
			loadAnswerFromNetwork(with: completionHandler)

		case .answerSet(let index):
			if let answer = answerSets[index].answers.randomElement() {
				completionHandler(answer)
			}
		}
	}

	private func loadAnswerFromNetwork(with completionHandler: @escaping (String?) -> Void) {
		networkAnswerModel.loadAnswer { [weak self] (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let networkAnswer):
					let answer = networkAnswer.magic.answer
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
