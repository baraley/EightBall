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
	@IBOutlet private var addNewAnswerSetButton: UIButton!
	
	// MARK: - Actions
	
	@IBAction private func switcherDidChange(_ switcher: UISwitch) {
		settingsDidChangeAction?(settingsModel)
	}
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = editButtonItem
	}
	
	// MARK: - Navigation
	
	enum SegueIdentifier: String {
		case answers
	}
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		return !isEditing
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard case .answers = segueIdentifier(for: segue) else { return }
		
		let viewController = segue.destination as! AnswerSetTableViewController
		
//		viewController.answers =
	}
	
	// MARK: - UITableViewDataSource
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return Section.allCases.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if Section(section) == .answerSets {
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
		return Section(section).headerText
	}
	
	override func tableView(_ tableView: UITableView,
							titleForFooterInSection section: Int) -> String? {
		return Section(section).footerText
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return Section(section) == .answerSets ? answerSetsHeaderView : nil
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return Section(at: indexPath) == .answerSets
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			let answerSet = answerSetsModelController.answerSets[indexPath.row]
			
			if answerSet.answers.isEmpty {
				answerSetsModelController.deleteAnswerSet(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .none)
			} else {
				showDeletingAlertForAnswerSet(at: indexPath)
			}
		}
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if isEditing, Section(at: indexPath) == .answerSets {
			showAlertWithTextField()
		}
	}
	
	override func tableView(_ tableView: UITableView,
							editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		
		return Section(at: indexPath) == .answerSets ? .delete : .none
	}
	
	override func tableView(_ tableView: UITableView,
							shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return Section(at: indexPath) == .answerSets
	}
}

private extension SettingsViewController {
	
	enum Section: Int, CaseIterable {
		case lazyMode, readAnswer, hapticFeedback, answerSets
		
		init(at indexPath: IndexPath) {
			self = Section.init(rawValue: indexPath.section)!
		}
		
		init(_ section: Int) {
			self = Section.init(rawValue: section)!
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
	
	var answerSetsHeaderView: UITableViewHeaderFooterView {
		let headerView = UITableViewHeaderFooterView(frame: .zero)
		headerView.addTrailingButton(addNewAnswerSetButton)
		return headerView
	}
	
	func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
		let section = Section(at: indexPath)
		
		cell.textLabel?.text = section.cellText
		cell.detailTextLabel?.text = ""
		cell.accessoryType = .none
		
		switch section {
		case .lazyMode:
			cell.accessoryView = lazyModeSwitch
			
		case .readAnswer:
			cell.accessoryView = readAnswerSwitch
			
		case .hapticFeedback:
			cell.accessoryView = hapticFeedbackSwitch
			
		case .answerSets:
			let answerSet = answerSetsModelController.answerSets[indexPath.row]
			cell.textLabel?.text = answerSet.name
			cell.detailTextLabel?.text = String(answerSet.answers.count)
			cell.accessoryType = .disclosureIndicator
		}
	}
	
	@IBAction func addNewAnswerSet() {
		 showAlertWithTextField()
	}
	
	func showDeletingAlertForAnswerSet(at indexPath: IndexPath) {
		let answerSet = answerSetsModelController.answerSets[indexPath.row]
		let numberOfAnswers = answerSet.answers.count
		let message = """
		Are you sure you want to delete set of answers that contains \(numberOfAnswers) answers?
		"""
		let ac = UIAlertController(title: "Delete answer set?", message: message, preferredStyle: .alert)
		
		ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
		
		ac.addAction(.init(title: "Delete", style: .destructive) {  _ in
			
			self.answerSetsModelController.deleteAnswerSet(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .none)
			})
		
		present(ac, animated: true)
	}
	
	func showAlertWithTextField() {
		let ac = UIAlertController(title: "Enter name", message: nil, preferredStyle: .alert)
		
		ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
		
		if let indexPath = tableView.indexPathForSelectedRow {
			ac.addTextField { (textField) in
				textField.text = self.answerSetsModelController.answerSets[indexPath.row].name
			}
			
			ac.addAction(UIAlertAction(title: "Save", style: .default) { _ in
				let textField = ac.textFields![0]
				
				if let name = textField.text, !name.isEmpty {
					var answerSet = self.answerSetsModelController.answerSets[indexPath.row]
					answerSet.name = name
					self.answerSetsModelController.save(answerSet)
					self.tableView.reloadData()
				}
			})
			
			tableView.deselectRow(at: indexPath, animated: true)
		} else {
			ac.addTextField()
			
			ac.addAction(UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
				let textField = ac.textFields![0]
				
				if let name = textField.text, !name.isEmpty {
					let newAnswerSet = AnswerSet(name: name, answers: [])
					self.answerSetsModelController.save(newAnswerSet)
					self.tableView.reloadData()
				}
			})
		}
		
		present(ac, animated: true)
	}
}
