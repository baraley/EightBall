//
//  SettingsModelController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/10/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

class SettingsModelController {
	
	// MARK: - Public
	
	private(set) lazy var currentSettinsModel: SettingsModel = loadSettinsModel()
	
	func save(_ settingsModel: SettingsModel) {
		currentSettinsModel = settingsModel
		
		FileManager.default.saveContent(currentSettinsModel, atPath: settingsModelFilePath)
	}
	
	// MARK: - Private
	
	private let settingsModelFilePath: String = {
		return FileManager.pathForFileInDocumentDirectory(withName: String(describing: SettingsModel.self))
	}()
	
	private func loadSettinsModel() -> SettingsModel {
		if let settingsModel = FileManager.default
			.loadSavedContent(atPath: settingsModelFilePath) as SettingsModel? {
			
			return settingsModel
		} else {
			let name = DefaultResouceName.settingsModel.rawValue
			return FileManager.default.loadContentFromBundle(withName: name)
		}
	}
}
