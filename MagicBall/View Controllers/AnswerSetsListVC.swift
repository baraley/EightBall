//
//  AnswerSetsListVC.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/14/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class AnswerSetsListVC: UITableViewController, SegueHandlerType {
	
	// MARK: - Public properties
	
	var answerSetsModelController: AnswerSetsModelController!
	
	// MARK: - Private properties
	
	private lazy var inputTextAlerController: InputTextAlerController = .init(
		presentingViewController: self
	)
	
	// MARK: - Life cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.rightBarButtonItem = editButtonItem
		navigationController?.setToolbarHidden(false, animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setToolbarHidden(true, animated: true)
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
		
		let viewController = segue.destination as! SetAnswersListVC
		
		if let indexPath = tableView.indexPathForSelectedRow {
			viewController.answerSet = answerSetsModelController.answerSets[indexPath.row]
			viewController.answerSetDidChangeHandler = { changedAnswerSet in
				
				self.answerSetsModelController.save(changedAnswerSet)
				
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		}
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answerSetsModelController.answerSets.count
	}
	
	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = String(describing: UITableViewCell.self)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		
		let answerSet = answerSetsModelController.answerSets[indexPath.row]
		cell.textLabel?.text = answerSet.name
		cell.detailTextLabel?.text = String(answerSet.answers.count)
		
		return cell
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
		if isEditing {
			editAnswerSet(at: indexPath)
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView,
							editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
}

// MARK: - Private
private extension AnswerSetsListVC {
	
	func showDeletingAlertForAnswerSet(at indexPath: IndexPath) {
		let answerSet = answerSetsModelController.answerSets[indexPath.row]
		let numberOfAnswers = answerSet.answers.count
		var message = """
		Are you sure you want to delete set of answers that contains \(numberOfAnswers)
		"""
		message += numberOfAnswers > 1 ? " answers?" : "answer?"
		
		
		let ac = UIAlertController(title: "Delete answer set?", message: message, preferredStyle: .alert)
		
		ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
		
		ac.addAction(.init(title: "Delete", style: .destructive) {  _ in
			
			self.answerSetsModelController.deleteAnswerSet(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .none)
			})
		
		present(ac, animated: true)
	}
	
	func editAnswerSet(at indexPath: IndexPath) {
		
		let placeholder = self.answerSetsModelController.answerSets[indexPath.row].name
		
		inputTextAlerController.showInputTextAlert(
			with: "Edit the answer set name",
			actionTitle: "Save",
			textFieldPlaceholder: placeholder) { [unowned self] (name) in
				
				var answerSet = self.answerSetsModelController.answerSets[indexPath.row]
				answerSet.name = name
				self.answerSetsModelController.save(answerSet)
				self.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
	
	@IBAction func acceptTextForNewAnswerSet() {
		
		inputTextAlerController.showInputTextAlert(
			with: "New answer set",
			actionTitle: "Add") { [unowned self] (name) in
				
				let numberOfAnswerSets = self.answerSetsModelController.answerSets.count
				
				let newAnswerSet = AnswerSet(name: name, answers: [])
				self.answerSetsModelController.save(newAnswerSet)
				
				let newAnswerSetIndexPath = IndexPath(row: numberOfAnswerSets, section: 0)
				self.tableView.insertRows(at: [newAnswerSetIndexPath], with: .automatic)
				self.tableView.scrollToRow(at: newAnswerSetIndexPath, at: .none, animated: true)
		}
	}
}
