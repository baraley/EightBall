//
//  SettingsStore.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/10/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class SettingsStore {

	// MARK: - Public

	private(set) lazy var currentSettings: Settings = loadSettings()

	func save(_ settings: Settings) {
		currentSettings = settings

		FileManager.default.saveContent(currentSettings, atPath: settingsFilePath)
	}

	// MARK: - Private

	private let settingsFilePath: String = {
		let fileName = String(describing: Settings.self)

		return FileManager.pathForFileInDocumentDirectory(withName: fileName)
	}()

	private func loadSettings() -> Settings {
		if let settings = FileManager.default.loadSavedContent(atPath: settingsFilePath) as Settings? {

			return settings
		} else {
			let name = DefaultResourceName.settings.rawValue

			return FileManager.default.loadContentFromBundle(withName: name)
		}
	}

}
