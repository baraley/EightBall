//
//  MessageAlertPresenter.swift
//  MagicBall
//
//  Created by Alexander Baraley on 26.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

struct MessageAlertPresenter {

	let message: String
	let actionTitle: String
	let action: (() -> Void)?

	init(message: String, actionTitle: String, action: (() -> Void)? = nil) {
		self.message = message
		self.actionTitle = actionTitle
		self.action = action
	}

	func present(in viewController: UIViewController) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: actionTitle, style: .default) { _ in
			self.action?()
		})

		viewController.present(alert, animated: true)
	}
}
