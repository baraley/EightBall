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
	
	var answerSetsModelController: AnswerSetsModelController!
	
	// MARK: - Outlets
	
	@IBOutlet private var lazyModeSwitch: UISwitch!
	@IBOutlet private var readAnswerSwitch: UISwitch!
	@IBOutlet private var hapticFeedbackSwitch: UISwitch!
	
	// MARK: - Actions
	
	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
		settingsDidChangeAction?(settingsModel)
	}
	
	// MARK: - Navigation
	
	enum SegueIdentifier: String {
		case predefinedAnswers
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard case .predefinedAnswers = segueIdentifier(for: segue) else { return }
		
		let viewController = segue.destination as! PredefinedAnswersTableViewController
		
//		viewController.predefinedAnswersModelController = predefinedAnswersModelController
	}
	
	// MARK: - UITableViewDataSource
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Section.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = String(describing: UITableViewCell.self)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		
		if let section = Section(rawValue: indexPath.row) {
			cell.textLabel?.text = section.cellText
			
			cell.accessoryType = section == .answerSets ? .disclosureIndicator : .none
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView,
							titleForFooterInSection section: Int) -> String? {
		return Section(rawValue: section)?.footerText
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView,
							shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		if let cell = tableView.cellForRow(at: indexPath) {
			return cell.accessoryType == .disclosureIndicator
		}
		return false
	}
}

private extension SettingsViewController {
	
	enum Section: Int, CaseIterable {
		case lazyMode, readAnswer, hapticFeedback, answerSets
		
		var cellText: String {
			switch self {
			case .lazyMode:			return "Lazy mode"
			case .readAnswer:		return "Read answer"
			case .hapticFeedback:	return "Haptic feedback"
			case .answerSets:		return "Answer sets"
			}
		}
		
		var footerText: String? {
			switch self {
			case .lazyMode:	return "When Lazy mode is on: tap the magic ball to make a request"
			default: 		return nil
			}
		}
	}
}
