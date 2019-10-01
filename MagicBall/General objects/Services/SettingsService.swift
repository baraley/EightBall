//
//  SettingsLoader.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let defaultSettingsFilePath = FileManager.pathForFileInDocumentDirectory(
	withName: String(describing: Settings.self)
)

final class SettingsService: SettingsServiceProtocol {

	private let settingsFilePath: String

	init(settingsFilePath: String = defaultSettingsFilePath) {
		self.settingsFilePath = settingsFilePath
	}

	func loadSettings() -> ManagedSettings {
		if let settings = FileManager.default.loadSavedContent(atPath: settingsFilePath) as ManagedSettings? {

			return settings
		} else {
			let name = DefaultResourceName.settings.rawValue

			return FileManager.default.loadContentFromBundle(withName: name)
		}
	}

	func save(_ settings: Settings) {
		let managedSettings = ManagedSettings(fromSettings: settings)

		FileManager.default.saveContent(managedSettings, atPath: settingsFilePath)
	}

}
