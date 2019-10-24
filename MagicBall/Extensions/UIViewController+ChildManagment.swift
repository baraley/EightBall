//
//  UIViewController+ChildManagment.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

extension UIViewController {

    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

	func showAlert(with message: String) {
		let alertPresenter = MessageAlertPresenter(message: message, actionTitle: L10n.Action.Title.ok)

		alertPresenter.present(in: self)
	}
}
