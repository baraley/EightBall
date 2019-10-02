//
//  SettingsLoader.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let defaultSettingsFilePath = FileManager.pathForFileInDocumentDirectory(withName: "Settings")

final class SettingsService: SettingsServiceProtocol {

	private let settingsFilePath: String

	init(settingsFilePath: String = defaultSettingsFilePath) {
		self.settingsFilePath = settingsFilePath
	}

	func loadSettings() -> Settings {
		let managedSettings: ManagedSettings

		if let settings = FileManager.default.loadSavedContent(atPath: settingsFilePath) as ManagedSettings? {
			managedSettings = settings
		} else {
			managedSettings = FileManager.default.loadContentFromBundle(withName: DefaultResourceName.settings.rawValue)
		}

		return managedSettings.toSettings()
	}

	func save(_ settings: Settings) {
		let managedSettings = ManagedSettings(fromSettings: settings)

		FileManager.default.saveContent(managedSettings, atPath: settingsFilePath)
	}

}
