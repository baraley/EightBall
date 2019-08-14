//
//  AnswerSetTableViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/11/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class AnswerSetTableViewController: UITableViewController {
	
	var answerSet: AnswerSet! {
		didSet {
			answerSetDidChangeHandler?(answerSet)
		}
	}
	
	var answerSetDidChangeHandler: ((AnswerSet) -> Void)?
	
	// MARK: - Life cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setup()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answerSet.answers.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
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
		showAlertWithTextField()
	}
	
	override func tableView(_ tableView: UITableView,
							editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		
		return .delete
	}
}

// MARK: - Private
private extension AnswerSetTableViewController {
	
	func setup() {
		navigationItem.rightBarButtonItem = editButtonItem
		navigationController?.setToolbarHidden(false, animated: true)
		navigationItem.title = answerSet.name
		tableView.reloadData()
	}
	
	@IBAction func showAlertWithTextField() {
		let ac = UIAlertController(title: "Enter answer text", message: nil, preferredStyle: .alert)
		
		ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
		
		if let indexPath = tableView.indexPathForSelectedRow {
			ac.addTextField { (textField) in
				textField.text = self.answerSet.answers[indexPath.row]
			}
			
			ac.addAction(UIAlertAction(title: "Save", style: .default) { _ in
				let textField = ac.textFields![0]
				
				if let answerText = textField.text, !answerText.isEmpty {
					self.answerSet.answers[indexPath.row] = answerText
					self.tableView.reloadRows(at: [indexPath], with: .automatic)
				}
			})
			
			tableView.deselectRow(at: indexPath, animated: true)
		} else {
			ac.addTextField()
			
			ac.addAction(UIAlertAction(title: "Save", style: .default) {  [unowned ac] _ in
				let textField = ac.textFields![0]
				
				if let newAnswerText = textField.text, !newAnswerText.isEmpty {
					self.answerSet.answers.append(newAnswerText)
					let newAnswerIndexPath = IndexPath(row: (self.answerSet.answers.count - 1), section: 0)
					self.tableView.insertRows(at: [newAnswerIndexPath], with: .automatic)
					self.tableView.scrollToRow(at: newAnswerIndexPath, at: .none, animated: true)
				}
			})
		}
		
		present(ac, animated: true)
	}
}
