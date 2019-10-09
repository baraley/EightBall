//
//  MagicBallViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let defaultAnswer = PresentableAnswer(text: L10n.initialMagicScreenMessage.uppercased())

final class MagicBallViewModel {

	enum Change {
		case answerNumber(Int), messageState(MagicBallView.AnswerState)
	}

	private(set) var isTapAllowed: Bool
	private(set) var hapticFeedbackIsOn: Bool
	private var isNeedToPronounce: Bool

	private let magicBallModel: MagicBallModel

	init(magicBallModel: MagicBallModel, settings: PresentableSetting) {
		self.magicBallModel = magicBallModel
		self.isTapAllowed = settings.lazyModeIsOn
		self.hapticFeedbackIsOn = settings.hapticFeedbackIsOn
		self.isNeedToPronounce = settings.readAnswerIsOn

		magicBallModel.changesHandler = { [weak self] change in
			self?.handleMagicBallModelChange(change)
		}
	}

	var obtainedAnswersNumber: Int {
		return magicBallModel.loadedAnswersNumber
	}

	private(set) var state: MagicBallView.AnswerState = .shown(defaultAnswer) {
		didSet {
			changesHandler?(.messageState(state))
		}
	}

	var changesHandler: ((Change) -> Void)?

	func shakeWasDetected() {
		requestNewAnswer()
	}

	func tapWasDetected() {
		requestNewAnswer()
	}

	func handleMessageShowingDidFinish() {
		if isNeedToPronounce {
			magicBallModel.pronounceAnswer()
		}
	}

	func endHandlingMessageShowing() {
		magicBallModel.stopPronouncing()
	}

}

// MARK: - Private Methods

private extension MagicBallViewModel {

	func requestNewAnswer() {
		magicBallModel.stopPronouncing()
		state = .hidden
		magicBallModel.loadAnswer()
	}

	func updateMessageState(with answer: PresentableAnswer?) {
		if let answer = answer {
			state = .shown(answer)
		} else {
			state = .shown(defaultAnswer)
		}
	}

	func handleMagicBallModelChange(_ change: MagicBallModel.Change) {
		switch change {
		case .answerNumber(let number):
			changesHandler?(.answerNumber(number))

		case .answerLoaded(let answer):
			updateMessageState(with: answer?.toPresentableAnswer())
		}
	}

}
