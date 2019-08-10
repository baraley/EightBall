//
//  SettingsModelController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/10/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

class SettingsModelController {
	
	private let settingsModelFilePath: String = {
		let documentDerictory = FileManager.default.urls(for: .documentDirectory,
														 in: .userDomainMask).first!
		let archiveURL = documentDerictory.appendingPathComponent(String(describing: SettingsModel.self))
		return archiveURL.path
	}()
	
	private(set) lazy var currentSettinsModel: SettingsModel = {
		if let settingsModel = loadSettingsModel() {
			return settingsModel
		} else {
			return loadDefaultSettingsModel()
		}
	}()
	
	func save(settingsModel: SettingsModel) {
		let encoder = JSONEncoder()
		
		currentSettinsModel = settingsModel
		
		do {
			let data = try encoder.encode(settingsModel)
			if FileManager.default.fileExists(atPath: settingsModelFilePath) {
				try FileManager.default.removeItem(atPath: settingsModelFilePath)
			}
			FileManager.default.createFile(
				atPath: settingsModelFilePath, contents: data, attributes: nil
			)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	private func loadSettingsModel() -> SettingsModel? {
		guard let data = FileManager.default.contents(atPath: settingsModelFilePath) else {
			return nil
		}
		
		let decoder = JSONDecoder()
		
		return (try? decoder.decode(SettingsModel.self, from: data))
	}
	
	private func loadDefaultSettingsModel() -> SettingsModel {
		let decoder = JSONDecoder()
		
		if 	let source = Bundle.main.path(forResource: "DefaultSettingsModel", ofType: nil),
			let data = FileManager.default.contents(atPath: source),
			let settingsModel = (try? decoder.decode(SettingsModel.self, from: data)) {
			
			return settingsModel
		} else {
			fatalError("Can not load default settings model")
		}
	}
}
