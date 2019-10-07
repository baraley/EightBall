//
//  SettingsViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let cellID = String(describing: UITableViewCell.self)
private let answerSetsCellID = "AnswerSetsCell"

final class SettingsViewController: UITableViewController {

	var settingsViewModel: SettingsViewModel {
		didSet {
			settingsViewModelDidChange()
		}
	}

	// MARK: - Initialization

	init(settingsViewModel: SettingsViewModel) {
		self.settingsViewModel = settingsViewModel

		super.init(style: .grouped)

		settingsViewModelDidChange()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Properties

	private lazy var lazyModeSwitch: UISwitch = initializeUISwitch()
	private lazy var readAnswerSwitch: UISwitch = initializeUISwitch()
	private lazy var hapticFeedbackSwitch: UISwitch = initializeUISwitch()

	private var answerSetsCell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: answerSetsCellID)

	// MARK: - Actions

	@objc
	private func switcherDidChange(_ switcher: UISwitch) {
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

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return Section.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell

		switch Section(at: indexPath) {
		case .lazyMode, .readAnswer, .hapticFeedback:
			cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		case .answerSets:
			cell = answerSetsCell
		}
		configure(cell, at: indexPath)

		return cell
	}

	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return Section(section).sectionFooterText
	}

	// MARK: - UITableViewDelegate

	override func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath) -> Bool {

		return Section(at: indexPath) == .answerSets
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard Section(at: indexPath) == .answerSets else { return }

		settingsViewModel.didSelectAnswerSetsCell()
	}

}

// MARK: - Private Methods

private extension SettingsViewController {

	func initializeUISwitch() -> UISwitch {
		let uiSwitch = UISwitch()
		uiSwitch.addTarget(self, action: #selector(switcherDidChange), for: .valueChanged)
		return uiSwitch
	}

	func settingsViewModelDidChange() {
		lazyModeSwitch.isOn = settingsViewModel.settings.lazyModeIsOn
		readAnswerSwitch.isOn = settingsViewModel.settings.readAnswerIsOn
		hapticFeedbackSwitch.isOn = settingsViewModel.settings.hapticFeedbackIsOn

		settingsViewModel.answerSetsNumberDidChangeHandler = { [unowned self] number in
			self.answerSetsCell.detailTextLabel?.text = String(self.settingsViewModel.answerSetsNumber)
		}
	}

	func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
		let section = Section(at: indexPath)

		cell.textLabel?.text = section.cellText

		switch section {
		case .lazyMode:  		cell.accessoryView = lazyModeSwitch
		case .readAnswer:		cell.accessoryView = readAnswerSwitch
		case .hapticFeedback: 	cell.accessoryView = hapticFeedbackSwitch
		case .answerSets:
			cell.detailTextLabel?.text = String(settingsViewModel.answerSetsNumber)
			cell.accessoryType = .disclosureIndicator
		}
	}

}

extension SettingsViewController {

	enum Section: Int {
		case lazyMode, readAnswer, hapticFeedback, answerSets

		static let count = 4

		init(at indexPath: IndexPath) {
			self = Section.init(rawValue: indexPath.section)!
		}

		init(_ section: Int) {
			self = Section.init(rawValue: section)!
		}

		var cellText: String {
			switch self {
			case .lazyMode:			return L10n.SettingsViewController.CellText.lazyMode
			case .readAnswer:		return L10n.SettingsViewController.CellText.readAnswer
			case .hapticFeedback:	return L10n.SettingsViewController.CellText.hapticFeedback
			case .answerSets:		return L10n.SettingsViewController.CellText.answerSets
			}
		}

		var sectionFooterText: String? {
			switch self {
			case .lazyMode: return L10n.SettingsViewController.SectionFooterText.lazyMode
			default:		return nil
			}
		}
	}

}
