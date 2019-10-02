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

	private(set) var isTapAllowed: Bool
	private(set) var hapticFeedbackIsOn: Bool
	private var isNeedToPronounce: Bool

	private let magicBallModel: MagicBallModel

	init(magicBallModel: MagicBallModel, settings: PresentableSetting) {
		self.magicBallModel = magicBallModel
		self.isTapAllowed = settings.lazyModeIsOn
		self.hapticFeedbackIsOn = settings.hapticFeedbackIsOn
		self.isNeedToPronounce = settings.readAnswerIsOn

		magicBallModel.answerDidChangeHandler = { [weak self] answer in
			self?.updateMessageState(with: answer?.toPresentableAnswer())
		}
	}

	private(set) var messageState: MagicBallView.State = .shown(defaultAnswer) {
		didSet {
			messageStateDidChangeHandler?(messageState)
		}
	}

	var messageStateDidChangeHandler: ((MagicBallView.State) -> Void)?

	func shakeWasDetected() {
		requestNewAnswer()
	}

	func tapWasDetected() {
		requestNewAnswer()
	}

	func didFinishMessageShowing() {
		if isNeedToPronounce {
			magicBallModel.pronounceAnswer()
		}
	}

	func viewDidDisappear() {
		magicBallModel.stopPronouncing()
	}

	// MARK: - Private -

	private func requestNewAnswer() {
		magicBallModel.stopPronouncing()
		messageState = .hidden
		magicBallModel.loadAnswer()
	}

	private func updateMessageState(with answer: PresentableAnswer?) {
		if let answer = answer {
			messageState = .shown(answer)
		} else {
			messageState = .shown(defaultAnswer)
		}
	}

}
