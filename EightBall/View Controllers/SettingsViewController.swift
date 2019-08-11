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
								 hapticFeedbackIsOn: hapticFeedbackSwitch.isOn,
								 onlyPredefinedAnswersModeIsOn: onlyPredefinedAnswersModeSwitch.isOn)
		}
		
		set {
			lazyModeSwitch.isOn						= newValue.lazyModeIsOn
			readAnswerSwitch.isOn					= newValue.readAnswerIsOn
			hapticFeedbackSwitch.isOn				= newValue.hapticFeedbackIsOn
			onlyPredefinedAnswersModeSwitch.isOn	= newValue.onlyPredefinedAnswersModeIsOn
		}
	}
	
	var settingsDidChangeAction: ((SettingsModel) -> Void)?
	
	var predefinedAnswersModelController: PredefinedAnswersModelController!
	
	// MARK: - Outlets
	
	@IBOutlet private var lazyModeSwitch: UISwitch!
	@IBOutlet private var readAnswerSwitch: UISwitch!
	@IBOutlet private var hapticFeedbackSwitch: UISwitch!
	@IBOutlet private var onlyPredefinedAnswersModeSwitch: UISwitch!
	
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
		
		viewController.predefinedAnswersModelController = predefinedAnswersModelController
	}
}
