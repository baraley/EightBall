//
//  SettingsViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, SegueHandlerType {
	
	// MARK: - Public properties
	
	var answerSetsModelController: AnswerSetsModelController!
	
	var settingsModel: SettingsModel {
		get {
			return SettingsModel(lazyModeIsOn: lazyModeSwitch.isOn,
								 readAnswerIsOn: readAnswerSwitch.isOn,
								 hapticFeedbackIsOn: hapticFeedbackSwitch.isOn)
		}
		
		set {
			lazyModeSwitch.isOn						= newValue.lazyModeIsOn
			readAnswerSwitch.isOn					= newValue.readAnswerIsOn
			hapticFeedbackSwitch.isOn				= newValue.hapticFeedbackIsOn
		}
	}
	
	var settingsDidChangeAction: ((SettingsModel) -> Void)?
	
	// MARK: - Outlets
	
	@IBOutlet private var lazyModeSwitch: UISwitch!
	@IBOutlet private var readAnswerSwitch: UISwitch!
	@IBOutlet private var hapticFeedbackSwitch: UISwitch!
	
	// MARK: - Actions
	
	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
//		settingsDidChangeAction?(settingsModel)
	}
	
	// MARK: - Navigation
	
	enum SegueIdentifier: String {
		case answers
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard case .answers = segueIdentifier(for: segue) else { return }
		
		let viewController = segue.destination as! AnswersTableViewController
		
//		viewController.answers = 
	}
	
	// MARK: - UITableViewDataSource
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Section.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if Section(at: section) == .answerSets {
			return answerSetsModelController.answerSets.count
		} else {
			return 1
		}
	}
	
	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = String(describing: UITableViewCell.self)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		
		configureCell(cell, at: indexPath)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView,
							titleForHeaderInSection section: Int) -> String? {
		return Section(at: section).headerText
	}
	
	override func tableView(_ tableView: UITableView,
							titleForFooterInSection section: Int) -> String? {
		return Section(at: section).footerText
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView,
							shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return Section(at: indexPath.section) == .answerSets
	}
}

private extension SettingsViewController {
	
	enum Section: Int, CaseIterable {
		case lazyMode, readAnswer, hapticFeedback, answerSets
		
		init(at index: Int) {
			self = Section(rawValue: index)!
		}
		
		var cellText: String {
			switch self {
			case .lazyMode:			return "Lazy mode"
			case .readAnswer:		return "Read answer"
			case .hapticFeedback:	return "Haptic feedback"
			case .answerSets:		return ""
			}
		}
		
		var headerText: String? {
			switch self {
			case .answerSets:	return "Answer sets"
			default: 			return nil
			}
		}
		
		var footerText: String? {
			switch self {
			case .lazyMode:	return "When Lazy mode is on: tap the magic ball to make a request"
			default: 		return nil
			}
		}
	}
	
	func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
		let section = Section(at: indexPath.section)
		
		cell.textLabel?.text = section.cellText
		cell.accessoryType = .none
		
		switch section {
		case .lazyMode:
			cell.accessoryView = lazyModeSwitch
			
		case .readAnswer:
			cell.accessoryView = readAnswerSwitch
			
		case .hapticFeedback:
			cell.accessoryView = hapticFeedbackSwitch
			
		case .answerSets:
			cell.textLabel?.text = answerSetsModelController.answerSets[indexPath.row].name
			cell.accessoryType = .disclosureIndicator
		}
	}
}
