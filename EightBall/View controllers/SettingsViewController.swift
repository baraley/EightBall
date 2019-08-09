//
//  SettingsViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
	
	@IBOutlet var lazyModeSwitch: UISwitch!
	@IBOutlet var readAnswerSwitch: UISwitch!
	@IBOutlet var hapticFeedbackSwitch: UISwitch!
	@IBOutlet var onlyPredefinedAnswersModeSwitch: UISwitch!
	
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
	
	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
		settingsDidChangeAction?(settingsModel)
	}
	
}
