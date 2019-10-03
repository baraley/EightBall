//
//  SettingsViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {

	var settingsViewModel: SettingsViewModel! {
		didSet {
			settingsViewModelDidChange()
		}
	}

	// MARK: - Outlets

	@IBOutlet private weak var lazyModeSwitch: UISwitch!
	@IBOutlet private weak var readAnswerSwitch: UISwitch!
	@IBOutlet private weak var hapticFeedbackSwitch: UISwitch!

	@IBOutlet private weak var answerSetsCell: UITableViewCell!

	// MARK: - Actions

	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
		switch switcher {
		case lazyModeSwitch:		settingsViewModel.settings.lazyModeIsOn.toggle()
		case readAnswerSwitch:		settingsViewModel.settings.readAnswerIsOn.toggle()
		case hapticFeedbackSwitch:	settingsViewModel.settings.hapticFeedbackIsOn.toggle()
		default:
			fatalError("Unhandled switcher did change \(switcher)")
		}
	}

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		settingsViewModel.answerSetsNumberDidChangeHandler = { [weak self] number in
			self?.updateAnswerSetsCell(with: number)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateAnswerSetsCell(with: settingsViewModel.answerSetsNumber)

		navigationController?.setToolbarHidden(true, animated: false)
	}

	// MARK: - UITableViewDelegate

	override func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath) -> Bool {

		return tableView.cellForRow(at: indexPath)?.accessoryType == .disclosureIndicator
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath == tableView.indexPath(for: answerSetsCell) else { return }

		settingsViewModel.didSelectAnswerSetsCell()
	}

	// MARK: - Private -

	private func settingsViewModelDidChange() {
		lazyModeSwitch.isOn = settingsViewModel.settings.lazyModeIsOn
		readAnswerSwitch.isOn = settingsViewModel.settings.readAnswerIsOn
		hapticFeedbackSwitch.isOn = settingsViewModel.settings.hapticFeedbackIsOn
	}

	private func updateAnswerSetsCell(with number: Int) {
		answerSetsCell.detailTextLabel?.text = String(number)
	}

}
