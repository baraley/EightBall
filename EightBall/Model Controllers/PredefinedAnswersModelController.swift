//
//  PredefinedAnswersModelController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/11/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class PredefinedAnswersModelController: NSObject {
	
	// MARK: - Public
	
	private(set) lazy var predefinedAnswers: [String] = loadPredefinedAnswers()
	
	func save(_ predefinedAnswer: String) {
		predefinedAnswers.append(predefinedAnswer)
		
		FileManager.default.saveContent(predefinedAnswers, atPath: predefinedAnswersFilePath)
	}
	
	// MARK: - Private
	
	private let predefinedAnswersFilePath: String = {
		return FileManager.pathForFileInDocumentDirectory(
			withName: DefaultResouce.predefinedAnswers.rawValue
		)
	}()
	
	private func loadPredefinedAnswers() -> [String] {
		if let answers = FileManager.default
			.loadSavedContent(atPath: predefinedAnswersFilePath) as [String]? {
			
			return answers
		} else {
			let name = DefaultResouce.predefinedAnswers.rawValue
			return FileManager.default.loadContentFromBundle(withName: name)
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
