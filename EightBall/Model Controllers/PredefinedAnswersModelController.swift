//
//  PredefinedAnswersModelController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/11/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class PredefinedAnswersModelController: NSObject {
	
	private(set) lazy var predefinedAnswers: [String] = {
		if let answers = loadPredefinedAnswers() {
			return answers
		} else {
			return loadDefaultPredefinedAnswers()
		}
	}()
	
	private let predefinedAnswersFilePath: String = {
		let documentDerictory = FileManager.default.urls(for: .documentDirectory,
														 in: .userDomainMask).first!
		let archiveURL = documentDerictory.appendingPathComponent("Predefined answers")
		return archiveURL.path
	}()
	
	func save(_ predefinedAnswer: String) {
		let encoder = JSONEncoder()
		
		predefinedAnswers.append(predefinedAnswer)
		
		do {
			let data = try encoder.encode(predefinedAnswers)
			if FileManager.default.fileExists(atPath: predefinedAnswersFilePath) {
				try FileManager.default.removeItem(atPath: predefinedAnswersFilePath)
			}
			FileManager.default.createFile(
				atPath: predefinedAnswersFilePath, contents: data, attributes: nil
			)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	private func loadPredefinedAnswers() -> [String]? {
		guard let data = FileManager.default.contents(atPath: predefinedAnswersFilePath) else {
			return nil
		}
		
		let decoder = JSONDecoder()
		
		return (try? decoder.decode([String].self, from: data))
	}
	
	private func loadDefaultPredefinedAnswers() -> [String] {
		let decoder = JSONDecoder()
		
		if 	let source = Bundle.main.path(forResource: "DefaultPredefinedAnswers", ofType: nil),
			let data = FileManager.default.contents(atPath: source) {
			
			do {
				return try decoder.decode([String].self, from: data)
			} catch {
				fatalError(error.localizedDescription)
			}
		} else {
			fatalError("Can not load default predefined answers")
		}
	}
}

extension PredefinedAnswersModelController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return predefinedAnswers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let identifier = String(describing: UITableViewCell.self)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		
		cell.textLabel?.text = predefinedAnswers[indexPath.row]
		
		return cell
	}
}
