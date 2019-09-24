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

	private(set) lazy var currentSettins: Settings = loadSettins()

	func save(_ settings: Settings) {
		currentSettins = settings

		FileManager.default.saveContent(currentSettins, atPath: settingsFilePath)
	}

	// MARK: - Private

	private let settingsFilePath: String = {
		let fileName = String(describing: Settings.self)

		return FileManager.pathForFileInDocumentDirectory(withName: fileName)
	}()

	private func loadSettins() -> Settings {
		if let settings = FileManager.default.loadSavedContent(atPath: settingsFilePath) as Settings? {

			return settings
		} else {
			let name = DefaultResouceName.settings.rawValue

			return FileManager.default.loadContentFromBundle(withName: name)
		}
	}

}
