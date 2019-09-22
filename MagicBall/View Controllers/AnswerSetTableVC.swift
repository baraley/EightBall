//
//  AnswerSetTableVC.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/11/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class AnswerSetTableVC: UITableViewController {
	
	// MARK: - Public properties
	
	var answerSet: AnswerSet! {
		didSet {
			if isViewLoaded { answerSetDidChangeHandler?(answerSet) }
		}
	}
	
	var answerSetDidChangeHandler: ((AnswerSet) -> Void)?
	
	// MARK: - Private properties
	
	private lazy var inputTextAlerController: InputTextAlerController = .init(
		presentingViewController: self
	)
	
	// MARK: - Life cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = answerSet.name
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answerSet.answers.count
	}
	
	override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let identifier = String(describing: UITableViewCell.self)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		
		cell.textLabel?.text = answerSet.answers[indexPath.row]
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			answerSet.answers.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .none)
		}
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		editAnswer(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(
		_ tableView: UITableView,
		editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		
		return .delete
	}
}

// MARK: - Private
private extension AnswerSetTableVC {
	
	func editAnswer(at indexPath: IndexPath) {
		let placeholder = self.answerSet.answers[indexPath.row]
		
		inputTextAlerController.showInputTextAlert(with: L10n.Alert.Title.editAnswer,
												   actionTitle: L10n.Action.Title.save,
												   textFieldPlaceholder: placeholder) { [unowned self] (answerText) in
			
			self.answerSet.answers[indexPath.row] = answerText
			self.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}
	
	@IBAction func acceptTextOfNewAnswer() {
		inputTextAlerController.showInputTextAlert(
		with: L10n.Alert.Title.newAnswer, actionTitle: L10n.Action.Title.add) { [unowned self] (answerText) in
			
			self.answerSet.answers.append(answerText)
			let newAnswerIndexPath = IndexPath(row: (self.answerSet.answers.count - 1), section: 0)
			self.tableView.insertRows(at: [newAnswerIndexPath], with: .automatic)
			self.tableView.scrollToRow(at: newAnswerIndexPath, at: .none, animated: true)
		}
	}
}
