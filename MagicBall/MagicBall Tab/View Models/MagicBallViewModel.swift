//
//  MagicBallViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let defaultMessage = L10n.initialMagicScreenMessage.uppercased()

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
			self?.updateMessageState(with: answer)
		}
	}

	private(set) var messageState: MagicBallView.State = .shown(defaultMessage) {
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

	private func updateMessageState(with answer: String?) {
		if let answer = answer {
			messageState = .shown(answer.uppercased())
		} else {
			messageState = .shown(defaultMessage)
		}
	}

}
