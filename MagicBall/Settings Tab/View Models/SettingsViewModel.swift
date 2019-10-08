//
//  SettingsViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 01.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class SettingsViewModel {

	private let answerSettingsModel: AnswerSettingsModel
	private let answerSetsModel: AnswerSetsModel
	private let answersCountingModel: AnswersCountingModel
	private let didSelectAnswerSetsCellHandler: (() -> Void)

	init(
		answerSettingsModel: AnswerSettingsModel,
		answerSetsModel: AnswerSetsModel,
		answersCountingModel: AnswersCountingModel,
		didSelectAnswerSetsCellHandler: @escaping (() -> Void)
	) {
		self.answerSettingsModel = answerSettingsModel
		self.answerSetsModel = answerSetsModel
		self.answersCountingModel = answersCountingModel
		self.didSelectAnswerSetsCellHandler = didSelectAnswerSetsCellHandler
		self.settings = answerSettingsModel.settings.toPresentableSettings()

		answerSetsModel.addObserver(self)
		answerSetsModel.loadAnswerSets()
	}

	var settings: PresentableSetting {
		didSet {
			answerSettingsModel.save(Settings(from: settings))
		}
	}

	var answerSetsNumber: Int {
		return answerSetsModel.numberOfAnswerSets()
	}

	var answerSetsNumberDidChangeHandler: ((Int) -> Void)?

	func didSelectAnswerSetsCell() {
		didSelectAnswerSetsCellHandler()
	}

	func resetAnswersNumber() {
		answersCountingModel.reset()
	}
}

extension SettingsViewModel: AnswerSetsModelObserver {

	func answerSetsModelDidChangeAnswerSets(_ model: AnswerSetsModel) {
		answerSetsNumberDidChangeHandler?(answerSetsNumber)
	}
}
