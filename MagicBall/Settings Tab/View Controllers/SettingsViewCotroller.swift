//
//  SettingsViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {

	// MARK: - Public properties

	var answerSetsStore: AnswerSetsStore!
	var settings: Settings {
		get {
			return Settings(
				lazyModeIsOn: lazyModeSwitch.isOn,
				readAnswerIsOn: readAnswerSwitch.isOn,
				hapticFeedbackIsOn: hapticFeedbackSwitch.isOn
			)
		}

		set {
			lazyModeSwitch.isOn			= newValue.lazyModeIsOn
			readAnswerSwitch.isOn		= newValue.readAnswerIsOn
			hapticFeedbackSwitch.isOn	= newValue.hapticFeedbackIsOn
		}
	}

	var settingsDidChangeAction: ((Settings) -> Void)?

	// MARK: - Outlets

	@IBOutlet private weak var lazyModeSwitch: UISwitch!
	@IBOutlet private weak var readAnswerSwitch: UISwitch!
	@IBOutlet private weak var hapticFeedbackSwitch: UISwitch!

	@IBOutlet private weak var answerSetsCell: UITableViewCell!

	// MARK: - Actions

	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
		settingsDidChangeAction?(settings)
	}

	// MARK: - Life cycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		answerSetsCell.detailTextLabel?.text = String(answerSetsStore.answerSets.count)
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			StoryboardSegue.Main(segue) == .answerSets,
			let viewController = segue.destination as? ListOfAnswerSetsViewController
			else {
				return
		}

		viewController.answerSetsStore = answerSetsStore
	}

	// MARK: - UITableViewDelegate

	override func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath) -> Bool {

		return tableView.cellForRow(at: indexPath)?.accessoryType == .disclosureIndicator
	}

}
