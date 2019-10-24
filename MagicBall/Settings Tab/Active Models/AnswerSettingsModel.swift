//
//  AnswerSettingsModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/10/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol SettingsServiceProtocol {

	func loadSettings() -> Settings
	func save(_ settings: Settings)
}

protocol HistoryCleanerServiceProtocol {

	func cleanHistory()
}

protocol AnswerSettingsObserver: class {

	func answerSettingsModelSettingsDidChange(_ model: AnswerSettingsModel)
}

final class AnswerSettingsModel {

	private let settingsService: SettingsServiceProtocol
	private let historyCleaner: HistoryCleanerServiceProtocol

	init(
		settingsService: SettingsServiceProtocol,
		historyCleaner: HistoryCleanerServiceProtocol
	) {
		self.settingsService = settingsService
		self.historyCleaner = historyCleaner
	}

	private(set) lazy var settings: Settings = {
		return settingsService.loadSettings()
	}()

	func save(_ settings: Settings) {
		self.settings = settings
		settingsService.save(settings)
		notifyObservers()
	}

	func cleanHistory() {
		historyCleaner.cleanHistory()
	}

	// MARK: - Observation

	private var observations: [ObjectIdentifier: Observation] = [:]

	func addObserver(_ observer: AnswerSettingsObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AnswerSettingsObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	private func notifyObservers() {
		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				observer.answerSettingsModelSettingsDidChange(self)

			} else {
				observations.removeValue(forKey: id)
			}
		}
	}
}

private extension AnswerSettingsModel {

	struct Observation {
        weak var observer: AnswerSettingsObserver?
    }
}
