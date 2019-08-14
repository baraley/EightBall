//
//  SettingsViewController.swift
//  MagicBall
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
	
	
	@IBOutlet private var answerSetsCell: UITableViewCell!
	
	// MARK: - Actions
	
	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
		settingsDidChangeAction?(settingsModel)
	}
	
	// MARK: - Life cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		answerSetsCell.detailTextLabel?.text = String(answerSetsModelController.answerSets.count)
	}

	
	// MARK: - Navigation
	
	enum SegueIdentifier: String {
		case answerSets
	}
	
//	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//		if let cell = sender as? UITableViewCell {
//			return cell.accessoryType == .disclosureIndicator
//		}
//	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard case .answerSets = segueIdentifier(for: segue) else { return }
		
		let viewController = segue.destination as! AnswerSetsListVC
		
		viewController.answerSetsModelController = answerSetsModelController
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView,
							shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return tableView.cellForRow(at: indexPath)?.accessoryType == .disclosureIndicator
	}
}
