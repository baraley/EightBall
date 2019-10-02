//
//  Settings.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct Settings {

	var lazyModeIsOn: Bool
	var readAnswerIsOn: Bool
	var hapticFeedbackIsOn: Bool

}

extension Settings {

	init(from presentableSettings: PresentableSetting) {
		self = .init(
			lazyModeIsOn: presentableSettings.lazyModeIsOn,
			readAnswerIsOn: presentableSettings.readAnswerIsOn,
			hapticFeedbackIsOn: presentableSettings.hapticFeedbackIsOn
		)
	}

	func toPresentableSettings() -> PresentableSetting {
		return .init(lazyModeIsOn: lazyModeIsOn, readAnswerIsOn: readAnswerIsOn, hapticFeedbackIsOn: hapticFeedbackIsOn)
	}
}
