//
//  Settings.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class ManagedSettings: Codable {

	var lazyModeIsOn: Bool
	var readAnswerIsOn: Bool
	var hapticFeedbackIsOn: Bool

	init(lazyModeIsOn: Bool, readAnswerIsOn: Bool, hapticFeedbackIsOn: Bool) {
		self.lazyModeIsOn		= lazyModeIsOn
		self.readAnswerIsOn		= readAnswerIsOn
		self.hapticFeedbackIsOn	= hapticFeedbackIsOn
	}

}

extension ManagedSettings {

	convenience init(fromSettings settings: Settings) {

		self.init(
			lazyModeIsOn: settings.lazyModeIsOn,
			readAnswerIsOn: settings.readAnswerIsOn,
			hapticFeedbackIsOn: settings.hapticFeedbackIsOn
		)
	}

	func toSettings() -> Settings {

		return Settings(
			lazyModeIsOn: lazyModeIsOn,
			readAnswerIsOn: readAnswerIsOn,
			hapticFeedbackIsOn: hapticFeedbackIsOn
		)
	}
}
