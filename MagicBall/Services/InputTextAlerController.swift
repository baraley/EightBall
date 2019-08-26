//
//  InputTextAlerController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/15/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class InputTextAlerController: NSObject, UITextFieldDelegate {
	
	private weak var presentingViewController: UIViewController?
	
	init(presentingViewController: UIViewController) {
		self.presentingViewController = presentingViewController
		
		super.init()
	}
	
	private var currentAction: UIAlertAction?
	
	// MARK: - Public
	
	func showInputTextAlert(with title: String,
							actionTitle: String,
							textFieldPlaceholder placeholder: String = "",
							completionHdandler: @escaping ((String) -> Void)) {
		
		let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		
		ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
		
		ac.addTextField { [unowned self] (textField) in
			textField.text = placeholder
			textField.addTarget(self, action: #selector(self.textDidChange(in:)), for: .editingDidBegin)
			textField.addTarget(self, action: #selector(self.textDidChange(in:)), for: .editingChanged)
		}
		
		currentAction = UIAlertAction(title: actionTitle, style: .default) { _ in
			let textField = ac.textFields![0]
			
			if let text = textField.text, !text.isEmpty {
				completionHdandler(text)
			}
		}
		
		ac.addAction(currentAction!)
		
		presentingViewController?.present(ac, animated: true)
	}
	
	// MARK: - Text field actions
	
	@objc func textDidChange(in textField: UITextField) {
		if !textField.hasText {
			currentAction?.isEnabled = false
		} else {
			currentAction?.isEnabled = true
		}
	}
}
